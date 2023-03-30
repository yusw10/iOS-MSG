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

    private let userInputHorizontalStackView = UIStackView().then { stackView in
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private let modeInputHorizontalStackView = UIStackView().then { stackView in
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private let modeTitleLabel = UILabel().then { label in
        label.textAlignment = .left
        label.text = "난이도:"
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    let modeTextLabel = UILabel().then { label in
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    private let partyInputHorizontalStackView = UIStackView().then { stackView in
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private let partyCountTitleLabel = UILabel().then { label in
        label.textAlignment = .left
        label.text = "파티원 수:"
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    let partyCountTextLabel = UILabel().then { label in
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
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
        self.checkButton.setImage(UIImage(named: "rectangle"), for: .normal)
        addSubView()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubView() {
        self.modeInputHorizontalStackView.addArrangedSubview(modeTitleLabel)
        self.modeInputHorizontalStackView.addArrangedSubview(modeTextLabel)

        self.partyInputHorizontalStackView.addArrangedSubview(partyCountTitleLabel)
        self.partyInputHorizontalStackView.addArrangedSubview(partyCountTextLabel)

        self.userInputHorizontalStackView.addArrangedSubview(modeInputHorizontalStackView)
        self.userInputHorizontalStackView.addArrangedSubview(partyInputHorizontalStackView)

        self.infoVerticalStackView.addArrangedSubview(nameLabel)
        self.infoVerticalStackView.addArrangedSubview(userInputHorizontalStackView)
        self.infoVerticalStackView.addArrangedSubview(rewardPriceLabel)

        self.totalHorizontalStackView.addArrangedSubview(infoVerticalStackView)
        self.totalHorizontalStackView.addArrangedSubview(checkButton)
        
        self.contentView.addSubview(bossImageView)
        self.contentView.addSubview(totalHorizontalStackView)
    }

    private func setLayout() {
        self.bossImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.2)
            make.height.equalTo(self.bossImageView.snp.width).multipliedBy(1.1)
        }

        self.totalHorizontalStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.bossImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView)
        }

        self.checkButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.totalHorizontalStackView)
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
    private let uncheckedImage = UIImage(systemName: "rectangle")
    private let checkedImage = UIImage(systemName: "checkmark.rectangle")
    
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
