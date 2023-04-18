//
//  SkillListViewCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/01/31.
//

import UIKit
import SnapKit
import Then

final class SkillListViewCell: UICollectionViewListCell {
    
    // MARK: - Properties
    
    static let id = "SkillListViewCell"
    private var task: Task<Void, Never>?
    
    private let horizontalStackView = UIStackView().then {
        $0.spacing = 10
        $0.alignment = .center
        $0.axis = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .MapleLightFont()
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = ""
        self.imageView.image = nil
        task?.cancel()
    }
    
    func configure(title: String, imageURL: String) {
        titleLabel.text = title
        
        guard let url = URL(string: imageURL) else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        task = Task {
            await self.imageView.fetchImage(request)
        }
    }
    
}

// MARK: - Private Methods

extension SkillListViewCell {
    
    // MARK: - Add View, Set Layout
    
    private func addSubViews() {
        self.contentView.addSubview(horizontalStackView)
        
        [imageView, titleLabel].forEach { view in
            horizontalStackView.addArrangedSubview(view)
        }
       
    }
    
    private func setLayouts() {
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top)
            make.leading.equalTo(self.contentView.snp.leading).offset(10)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-10)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.horizontalStackView.snp.top).offset(5)
            make.bottom.equalTo(self.horizontalStackView.snp.bottom).offset(-5)

            make.width.height.equalTo(self.contentView.snp.width).multipliedBy(0.1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.horizontalStackView.snp.top).offset(5)
            make.bottom.equalTo(self.horizontalStackView.snp.bottom).offset(-5)
        }
    }
    
}

