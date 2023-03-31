//
//  WeeklyBossListViewCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/16.
//

import UIKit
import SnapKit
import Then

final class WeeklyBossCalculatorViewCell: UICollectionViewListCell {
    static let id = "WeeklyBossCalculatorViewCell"
    
    private let bossImageView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
    }

    private let totalHorizontalStackView = UIStackView().then { stackView in
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 3
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private let infoVerticalStackView = UIStackView().then { stackView in
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private let nameLabel = UILabel().then { label in
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    private let modeInputHorizontalStackView = UIStackView().then { stackView in
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private let modeTitleLabel = UILabel().then { label in
        label.textAlignment = .left
        label.text = "난이도:"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    let modeTextField = UITextField().then { textField in
        textField.textAlignment = .left
        textField.borderStyle = .roundedRect
        textField.attributedPlaceholder = NSAttributedString(
            string: "난이도를 선택하세요.",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)])
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.translatesAutoresizingMaskIntoConstraints = false
    }

    private let partyInputHorizontalStackView = UIStackView().then { stackView in
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private let partyCountTitleLabel = UILabel().then { label in
        label.textAlignment = .left
        label.text = "파티원 수:"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    let partyCountTextField = UITextField().then { textField in
        textField.textAlignment = .left
        textField.borderStyle = .roundedRect
        textField.attributedPlaceholder = NSAttributedString(
            string: "파티원 수를 선택하세요.",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)])
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.translatesAutoresizingMaskIntoConstraints = false
    }

    private let rewardPriceLabel = UILabel().then { label in
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let checkButton = CheckBox().then { button in
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.layer.addBorder([.bottom], color: .systemGray4, width: 1.5)
        addSubView()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubView() {
        self.modeInputHorizontalStackView.addArrangedSubview(modeTitleLabel)
        self.modeInputHorizontalStackView.addArrangedSubview(modeTextField)

        self.partyInputHorizontalStackView.addArrangedSubview(partyCountTitleLabel)
        self.partyInputHorizontalStackView.addArrangedSubview(partyCountTextField)

        self.infoVerticalStackView.addArrangedSubview(nameLabel)
        self.infoVerticalStackView.addArrangedSubview(modeInputHorizontalStackView)
        self.infoVerticalStackView.addArrangedSubview(partyInputHorizontalStackView)
        self.infoVerticalStackView.addArrangedSubview(rewardPriceLabel)

        self.totalHorizontalStackView.addArrangedSubview(infoVerticalStackView)
        self.totalHorizontalStackView.addArrangedSubview(checkButton)
        
        self.contentView.addSubview(bossImageView)
        self.contentView.addSubview(totalHorizontalStackView)
    }

    private func setLayout() {
        self.bossImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView).offset(5)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.23)
            make.height.equalTo(self.bossImageView.snp.width).multipliedBy(1.1)
        }

        self.totalHorizontalStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.bossImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self.contentView).inset(5)
            make.top.bottom.equalTo(self.contentView).inset(20)
        }

        self.checkButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.contentView).inset(60)
        }
    }

    func configureCell(name: String, imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)

        self.nameLabel.text = name

        Task {
            await self.bossImageView.fetchJobImage(request)
        }
    }
    
    func configurePriceCell(price: String) {
        self.rewardPriceLabel.text = price
    }
}

class CheckBox: UIButton {
    private let uncheckedImage = UIImage(systemName: "square")
    private let checkedImage = UIImage(systemName: "checkmark.square")
    
    private var isChecked: Bool = false {
        didSet {
            if isChecked == false {
                self.setImage(uncheckedImage, for: .normal)
            } else {
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
