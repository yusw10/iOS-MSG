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
        self.jobImage.image = nil
        task?.cancel() // cancel을 해주지 않으면 task.isCancelled는 false로 출력된다.
    }
    
    private func setupDefault() {
        contentView.addSubview(jobImageShadowView)
        jobImageShadowView.addSubview(jobImage)
        
        jobImage.snp.makeConstraints({ make in
            make.top.leading.bottom.trailing.equalTo(contentView)
        })
    }
    
    func setupCellImage(title: String) {
        task = Task {
            await jobImage.fetchImage(title)
        }
    }
}

// TODO: Task cancel 적용 시키기
extension UIImageView {
    func fetchImage(_ url: String) async {
        if let thumbnail = await ImageCacheManager.shared.getCachedImage(url: url) {
            self.image = thumbnail
            return
        }
        
        guard let newURL = URL(string: url) else {
            return
        }
        
        do {
            let (data, _) = try await URLSession(configuration: .ephemeral).data(from: newURL)
            guard let thumbnail = UIImage(data: data) else {
                return
            }
            ImageCacheManager.shared.saveCache(image: thumbnail, url: url)
            self.image = thumbnail
        } catch {
            // 에러 처리
        }
    }
}

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()
    
    var cacheManger: NSCache<NSString, UIImage> {
        self.cache.countLimit = 10
        self.cache.totalCostLimit = 10
        return cache
    }
    
    private init() { }
    
    func getCachedImage(url: String) async -> UIImage? {
        let key = NSString(string: url)
        return cacheManger.object(forKey: key)
    }
    
    func saveCache(image: UIImage, url: String) {
        let key = NSString(string: url)
        cacheManger.setObject(image, forKey: key)
    }
}
