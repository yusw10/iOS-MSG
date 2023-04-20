//
//  LevelAndForceCell.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/03/17.
//

import UIKit
import SnapKit
import Then

class LevelAndForceCell: UICollectionViewCell {
    static let id = "LevelAndForceCell"
    
    private let verticalStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let modeLabel = UILabel().then { label in
        label.textAlignment = .center
        label.font = .MapleLightFont()
        label.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        label.textColor = .white
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let infoLabel = UILabel().then { label in
        label.textAlignment = .center
        label.font = .MapleLightFont()
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.contentView.addSubview(verticalStackView)
        self.verticalStackView.addArrangedSubview(modeLabel)
        self.verticalStackView.addArrangedSubview(infoLabel)
        
        self.verticalStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.contentView)
        }
        
        self.modeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.verticalStackView)
        }
        
        self.infoLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.verticalStackView)
        }
    }
    
    func configureCell(mode: String, info: Int) {
        let infoText = String(info)
        
        self.modeLabel.text = mode
        self.infoLabel.text = infoText
    }
}
