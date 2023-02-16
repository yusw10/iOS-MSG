//
//  SkillListViewCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/01/31.
//

import UIKit
import SnapKit
import Then

final class SkillListViewCell: UICollectionViewListCell {
    
    // MARK: - Properties
    
    static let id = "SkillListViewCell"
    
    private let horizontalStackView = UIStackView().then {
        $0.spacing = 10
        $0.axis = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
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
        
        self.configure(title: "", image: nil)
    }
    
    func configure(title: String, image: UIImage?) {
        titleLabel.text = title
        imageView.image = image
    }
    
}

// MARK: - Private Methods

extension SkillListViewCell {
    
    // MARK: - Add View, Set Layout
    
    private func addSubViews() {
        self.contentView.addSubview(horizontalStackView)
        
        [imageView, titleLabel].forEach { view in
            horizontalStackView.addArrangedSubview(view)
        }
       
    }
    
    private func setLayouts() {
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top).offset(10)
            make.leading.equalTo(self.contentView.snp.leading).offset(10)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.1)
            make.height.equalTo(self.contentView.snp.width).multipliedBy(0.1)
        }
    }
    
}

