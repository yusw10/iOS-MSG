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
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        label.textColor = .white
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let infoLabel = UILabel().then { label in
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
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

class DescriptionCell: UICollectionViewCell {
    static let id = "DescriptionCell"
    
    private let descriptionLabel = UILabel().then { label in
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
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
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let priceLabel = UILabel().then { label in
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
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

// MARK: ItemCell
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
        label.font = UIFont.preferredFont(forTextStyle: .body)
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
        Task {
            await self.imageView.fetchImage(imageURL)
        }
        self.nameLabel.text = name
    }
    
}

class MainBossImageCell: UICollectionViewCell {
    static let id = "MainBossImageCell"
    private var task: Task<Void, Never>?
    
    private let containerView = UIView().then { view in
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let imageView = UIImageView().then { imageView in
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
        task?.cancel()
    }
    
    private func setLayout() {
        self.contentView.addSubview(containerView)
        self.containerView.addSubview(imageView)
        
        self.containerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.contentView)
        }
        
        self.imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.containerView)
            make.width.equalTo(self.containerView).multipliedBy(0.5)
            make.height.equalTo(self.containerView)
        }
    }
    
    func configureImage(from imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        task = Task {
            await self.imageView.fetchJobImage(request)
        }
    }
}

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
