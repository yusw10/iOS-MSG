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

    private lazy var skillImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var verticalStackView = UIStackView().then {
        $0.sizeToFit()
        $0.distribution = .equalSpacing
        $0.spacing = 5
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.font = .MapleTitleFont()
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.sizeToFit()
        $0.font = .MapleLightFont()
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
        
        guard let url = URL(string: imageURL) else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        Task {
            await self.skillImageView.fetchImage(request)
        }
    }
    
}

// MARK: - Private Methods

extension SkillDetailViewCell {
    
    // MARK: - Add View, Set Layout
    
    private func addSubViews() {
        self.contentView.addSubview(skillImageView)
        self.contentView.addSubview(verticalStackView)
        
        [titleLabel, descriptionLabel].forEach { view in
            verticalStackView.addArrangedSubview(view)
        }
    }
    
    private func setLayouts() {
        skillImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView.snp.leading).offset(10)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.15)
            make.height.equalTo(self.skillImageView.snp.width)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.skillImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-10)
            make.top.equalTo(self.contentView.snp.top).offset(10)
            make.centerY.equalTo(self.skillImageView.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.top).priority(750)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).priority(750)
        }
    }
    
}
