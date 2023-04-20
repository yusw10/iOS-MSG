//
//  MainBossImageCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/04/20.
//

import UIKit

class MainBossImageCell: UICollectionViewCell {
    static let id = "MainBossImageCell"
    private var task: Task<Void, Never>?
    
    private let containerView = UIView().then { view in
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let imageView = UIImageView().then { imageView in
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
        task?.cancel()
    }
    
    private func setLayout() {
        self.contentView.addSubview(containerView)
        self.containerView.addSubview(imageView)
        
        self.containerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.contentView)
        }
        
        self.imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.containerView)
            make.width.equalTo(self.containerView).multipliedBy(0.5)
            make.height.equalTo(self.containerView)
        }
    }
    
    func configureImage(from imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        task = Task {
            await self.imageView.fetchImage(request)
        }
    }
}
