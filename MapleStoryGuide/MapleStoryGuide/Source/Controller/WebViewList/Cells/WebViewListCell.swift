//
//  WebViewListCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/04/11.
//

import UIKit

final class WebViewListCell: UICollectionViewCell {
    
    static let id = "WebViewListCell"
    
    private lazy var verticalStackView = UIStackView().then { stackView in
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var nameLabel = UILabel().then { label in
        label.font = .MapleTitleFont()
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var descriptionLabel = UILabel().then { label in
        label.font = .MapleLightDesciptionFont()
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, description: String) {
        nameLabel.text = title
        descriptionLabel.text = description
    }
    
}

private extension WebViewListCell {
    
    func setupView() {
        self.contentView.addSubview(verticalStackView)
        
        [nameLabel, descriptionLabel].forEach { view in
            verticalStackView.addArrangedSubview(view)
        }
    }
    
    func setupLayout() {
        verticalStackView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(self.contentView).inset(10)
        }
    }
    
}
