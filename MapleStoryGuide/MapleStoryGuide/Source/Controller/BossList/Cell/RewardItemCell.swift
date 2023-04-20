//
//  RewardItemCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/04/20.
//

import UIKit

class RewardItemCell: UICollectionViewCell {
    static let id = "RewardItemCell"
    
    private let horizontalStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let imageView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let nameLabel = UILabel().then { label in
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .MapleLightFont()
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
        self.contentView.layer.addBorder([.bottom], color: .systemGray4, width: 1.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() { // imageView Scale 맞추기
        self.contentView.addSubview(horizontalStackView)
        self.horizontalStackView.addArrangedSubview(imageView)
        self.horizontalStackView.addArrangedSubview(nameLabel)
        
        self.horizontalStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
        
        self.imageView.snp.makeConstraints { make in
            make.height.equalTo(self.horizontalStackView)
            make.width.equalTo(self.horizontalStackView).multipliedBy(0.2)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.imageView.snp.trailing).offset(20)
        }
    }
    
    func configureCell(imageURL: String, name: String) {
        self.nameLabel.text = name
        guard let url = URL(string: imageURL) else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        Task {
            await self.imageView.fetchImage(request)
        }
    }
    
}
