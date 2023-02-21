//
//  SkillDetailViewCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/02/21.
//

import UIKit

final class SkillDetailViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let id = "SkillDetailViewCell"

    private lazy var horizontalStackView = UIStackView().then {
        $0.spacing = 10
        $0.axis = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var skillImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var verticalStackView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.spacing = 5
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.font = .preferredFont(forTextStyle: .title3, compatibleWith: UITraitCollection(legibilityWeight: .bold))
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .caption2)
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
        
    // MARK: - initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubViews()
        setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(imageURL: String, title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        Task {
            await self.skillImageView.fetchImage(imageURL)
        }
    }
    
}

// MARK: - Private Methods

extension SkillDetailViewCell {
    
    // MARK: - Add View, Set Layout
    
    private func addSubViews() {
        self.contentView.addSubview(horizontalStackView)
        
        [skillImageView, verticalStackView].forEach { view in
            horizontalStackView.addArrangedSubview(view)
        }
        
        [titleLabel, descriptionLabel].forEach { view in
            verticalStackView.addArrangedSubview(view)
        }
    }
    
    private func setLayouts() {
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top).offset(10)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
            make.leading.equalTo(self.contentView.snp.leading).offset(10)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-10)
        }
        
        skillImageView.snp.makeConstraints { make in
            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.15).priority(750)
            make.height.greaterThanOrEqualTo(self.contentView.snp.width).multipliedBy(0.15).priority(750)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.top).priority(750)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).priority(750)
        }
    }
    
}
