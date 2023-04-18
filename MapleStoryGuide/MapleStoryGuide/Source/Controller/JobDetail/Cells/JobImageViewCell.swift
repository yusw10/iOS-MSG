//
//  JobImageViewCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/02/02.
//

import UIKit
import SnapKit
import Then

final class JobImageViewCell: UICollectionViewListCell {
    
    // MARK: - Properties
    
    static let id = "JobImageViewCell"
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
    }
    
    func configure(imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        Task {
            await self.imageView.fetchImage(request)
        }
    }
    
}

// MARK: - Private Methods

extension JobImageViewCell {
    
    // MARK: - Add View, Set Layout
    
    private func addSubViews() {
        self.contentView.addSubview(imageView)
    }
    
    private func setLayouts() {
        imageView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(self.contentView)
            make.height.equalTo(imageView.snp.width).multipliedBy(0.5).priority(750)
        }
    }
        
}
