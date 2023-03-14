//
//  CharacterViewCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/14.
//

import UIKit
import SnapKit
import Then

final class CharacterViewCell: UICollectionViewCell {
    
    static let id = "CharacterViewCell"
    
    private lazy var verticalStackView = UIStackView().then {
        $0.alignment = .center
        $0.spacing = 10
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "phone.circle.fill")
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var worldLabel = UILabel().then {
        $0.text = "엘리시움"
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.text = "디아런라딘"
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var totalPriceLabel = UILabel().then {
        $0.text = "총 가격"
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CharacterViewCell {
    
    func setupView() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        self.contentView.addSubview(verticalStackView)
        
        [thumbnailImageView, worldLabel, nameLabel, totalPriceLabel].forEach { view in
            verticalStackView.addArrangedSubview(view)
        }
    }
    
    func setupLayout() {
        verticalStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self.contentView).inset(10)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.width.equalTo(verticalStackView.snp.width)
        }
    }
    
}
