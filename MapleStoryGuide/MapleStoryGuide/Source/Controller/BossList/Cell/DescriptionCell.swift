//
//  DescriptionCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/04/20.
//

import UIKit

class DescriptionCell: UICollectionViewCell {
    static let id = "DescriptionCell"
    
    private let descriptionLabel = UILabel().then { label in
        label.textAlignment = .center
        label.font = .MapleLightFont()
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
        configureText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.contentView.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.top.leading.equalTo(self.contentView)
        }
    }
    
    private func configureText() {
        descriptionLabel.text = "해당 보스는 적정 포스가 존재하지 않습니다."
    }
}
