//
//  BossImageCell.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/03/15.
//

import UIKit
import SnapKit
import Then

class BossImageCell: UICollectionViewListCell {
    static let id = "BossImageCell"
    private var task: Task<Void, Never>?
    
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
        self.contentView.addSubview(imageView)
        
        self.imageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
    }
    
    func configureImage(from imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)

        task = Task {
            await imageView.fetchImage(request)
        }
    }
}
