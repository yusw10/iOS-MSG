//
//  JobListCollectionViewCell.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/02/06.
//

import UIKit
import Then
import SnapKit

final class JobListCollectionViewCell: UICollectionViewCell {
    var task: Task<Void, Never>?
    
    //MARK: - CollectionViewCell Properties
    
    let jobImageShadowView = UIView().then {
        $0.layer.shadowOffset = CGSize(width: 5, height: 5)
        $0.layer.shadowOpacity = 0.7
        $0.layer.shadowRadius = 5

        $0.layer.shadowColor = UIColor.gray.cgColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let jobImage = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
    }
    
    //MARK: - CollectionViewCell Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefault()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        debugPrint("JobListCollectionViewCell - Initialize Error")
    }
    
    //MARK: - CollectionViewCell Setup Method
    override func prepareForReuse() {
        super.prepareForReuse()
        
        task?.cancel()
        self.jobImage.image = nil
    }
    
    private func setupDefault() {
        contentView.addSubview(jobImageShadowView)
        jobImageShadowView.addSubview(jobImage)
        
        jobImage.snp.makeConstraints({ make in
            make.top.leading.bottom.trailing.equalTo(contentView)
        })
    }
    
    func setupCellImage(title: String) {
        guard let url = URL(string: title) else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)

        task = Task {
            await jobImage.fetchJobImage(request)
        }
    }
}

// TODO: Task cancel 적용 시키기
extension UIImageView {
    func fetchImage(_ url: String) async {
        guard let newURL = URL(string: url) else {
            return
        }
        
        do {
            let (data, _) = try await URLSession(configuration: .default).data(from: newURL)
            guard let thumbnail = UIImage(data: data)?.downSampling(for: self.frame.size) else {
                return
            }
            self.image = thumbnail
        } catch {
            // 에러 처리
        }
    }
    
    // MARK: 교착 상태 발생
    // 중간에 있는 await이 있는 지점에서 해당 쓰레드에 대한 제어권을 시스템에 넘기기 때문에 해당 쓰레드에서 다른 작업을 수행할 수 있다.
    // 함수를 Task에서 실행시키는 동안 쓰레드 내부에서 다른 context도 동시에 실행 -> 현재 쓰레드 충돌의 원인?
    func fetchJobImage(_ urlRequest: URLRequest) async {
        if let response = URLCache.shared.cachedResponse(for: urlRequest) {
            self.image = UIImage(data: response.data)?.downSampling(for: self.frame.size)
            return
        }
        
        do {
            let (data, response) = try await URLSession(configuration: .ephemeral).data(for: urlRequest)
            self.image = UIImage(data: data)?.downSampling(for: self.frame.size)
            let cacheResponse = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cacheResponse, for: urlRequest)
        } catch {
            return
        }
    }
}

extension UIImage {
    func downSampling(for size: CGSize) -> UIImage? {
        let render = UIGraphicsImageRenderer(size: size)
        return render.image { [weak self] _ in
            self?.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}


actor ImageLoader {
    static let shared = ImageLoader()
    
    var cache = URLCache.shared
    
    func fetchImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        if let response = cache.cachedResponse(for: request) {
            return UIImage(data: response.data)
        } else {
            do {
                let (data, response) = try await URLSession(configuration: .ephemeral).data(for: request)
                let cacheResponse = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cacheResponse, for: request)
                return UIImage(data: data)
            } catch {
                return nil
            }
        }
    }
}
