//
//  SkillDetailViewCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/02/02.
//

import UIKit
import SnapKit
import Then

final class SkillDetailViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let id = "SkillDetailViewCell"

    private let horizontalStackView = UIStackView().then {
        $0.spacing = 10
        $0.axis = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let skillImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let verticalStackView = UIStackView().then {
        $0.spacing = 10
        $0.distribution = .fillEqually
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let description20Label = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let description40Label = UILabel().then {
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
    
    func configure(imageURL: String, title: String, description20: String, description40: String) {
        Task {
            await self.skillImageView.fetchImage(imageURL)
        }
        titleLabel.text = title
        description20Label.text = description20
        description40Label.text = description40
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
        
        [titleLabel, description20Label, description40Label].forEach { view in
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
            make.width.height.equalTo(self.contentView.snp.width).multipliedBy(0.2).priority(750)
        }
    }
    
}
