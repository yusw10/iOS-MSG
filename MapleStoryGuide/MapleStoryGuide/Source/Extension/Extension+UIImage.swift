//
//  Extension+UIImage.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/04/20.
//

import UIKit

// TODO: Task cancel 적용 시키기
extension UIImageView {
    // MARK: 교착 상태 발생
    // 중간에 있는 await이 있는 지점에서 해당 쓰레드에 대한 제어권을 시스템에 넘기기 때문에 해당 쓰레드에서 다른 작업을 수행할 수 있다.
    // 함수를 Task에서 실행시키는 동안 쓰레드 내부에서 다른 context도 동시에 실행 -> 현재 쓰레드 충돌의 원인?
    func fetchImage(_ urlRequest: URLRequest) async {
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
