//
//  RewardPriceCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/04/20.
//

import UIKit

class RewardPriceCell: UICollectionViewCell {
    static let id = "RewardPriceCell"
    
    private let horizontalStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = true
    }
    
    private let modeLabel = UILabel().then { label in
        label.textAlignment = .left
        label.font = .MapleLightFont()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let priceLabel = UILabel().then { label in
        label.textAlignment = .left
        label.font = .MapleLightFont()
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
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
    
    private func setLayout() {
        self.contentView.addSubview(horizontalStackView)
        self.horizontalStackView.addArrangedSubview(modeLabel)
        self.horizontalStackView.addArrangedSubview(priceLabel)
        
        self.horizontalStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.contentView)
        }
        
        self.modeLabel.snp.makeConstraints { make in
            make.width.equalTo(self.horizontalStackView).multipliedBy(0.3)
        }
    }
    
    func configureCell(mode: String, price: Int) {
        let priceText = NumberFormatterManager.shared.format(from: price)
        
        self.modeLabel.text = mode
        self.priceLabel.text = priceText
    }
}
