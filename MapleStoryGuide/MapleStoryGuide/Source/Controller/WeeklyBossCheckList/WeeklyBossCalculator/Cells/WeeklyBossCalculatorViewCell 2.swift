//
//  WeeklyBossListViewCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/16.
//

import UIKit
import SnapKit
import Then

// TODO: 디자인 살짝 수정

final class WeeklyBossCalculatorViewCell: UITableViewCell {
    static let id = "WeeklyBossCalculatorViewCell"
    
    private let bossImageView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
    }

    private let totalHorizontalStackView = UIStackView().then { stackView in
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let nameLabel = UILabel().then { label in
        label.font = .MapleTitleFont()
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let checkHorizontalStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let checkLabel = UILabel().then { label in
        label.text = "클리어"
        label.font = .MapleTitleFont()
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let checkButton = CheckBox().then { button in
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubView()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubView() {
        self.checkHorizontalStackView.addArrangedSubview(checkLabel)
        self.checkHorizontalStackView.addArrangedSubview(checkButton)
        
        self.totalHorizontalStackView.addArrangedSubview(nameLabel)
        self.totalHorizontalStackView.addArrangedSubview(checkHorizontalStackView)
        
        self.contentView.addSubview(bossImageView)
        self.contentView.addSubview(totalHorizontalStackView)
    }

    private func setLayout() {
        self.bossImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView).offset(10)
            make.centerY.equalTo(self.contentView)
            make.height.equalTo(self.contentView).multipliedBy(0.8)
            make.width.equalTo(self.bossImageView.snp.height)
        }

        self.totalHorizontalStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.bossImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self.contentView).inset(15)
            make.centerY.equalTo(self.contentView)
        }
    }

    func configureCell(name: String) {
        self.nameLabel.text = name
        self.bossImageView.image = UIImage(named: name)
    }
}

class CheckBox: UIButton {
    private let uncheckedImage = UIImage(systemName: "square")
    private let checkedImage = UIImage(systemName: "checkmark.square")
    private let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)

    private var isChecked: Bool = false {
        didSet {
            if isChecked == false {
                self.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
                self.setImage(uncheckedImage, for: .normal)
            } else {
                self.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
                self.setImage(checkedImage, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCheckState(state: Bool) {
        self.isChecked = state
    }
    
    func getCheckState() -> Bool {
        return isChecked
    }
}
