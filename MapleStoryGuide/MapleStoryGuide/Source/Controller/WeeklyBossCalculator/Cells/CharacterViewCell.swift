//
//  CharacterViewCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/14.
//

import UIKit
import SnapKit
import Then

final class CharacterViewCell: UICollectionViewListCell {
    
    static let id = "CharacterViewCell"
    
    private lazy var horizontalStackView = UIStackView().then {
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.axis = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var nameLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var worldLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var totalPriceLabel = UILabel().then {
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
    
    func configure(name: String, world: String, totalCount: String) {
        nameLabel.text = name
        worldLabel.text = world
        totalPriceLabel.text = totalCount
    }
    
}

private extension CharacterViewCell {
    
    func setupView() {
        self.contentView.addSubview(horizontalStackView)
        
        [worldLabel, nameLabel, totalPriceLabel].forEach { view in
            horizontalStackView.addArrangedSubview(view)
        }
    }
    
    func setupLayout() {
        horizontalStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self.contentView).inset(10)
        }
    }
    
}
