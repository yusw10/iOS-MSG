//
//  SkillListViewCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/01/31.
//

import UIKit
import SnapKit
import Then

final class SkillListViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let id = "SkillListViewCell"
    
    private let horizontalStackView = UIStackView().then {
        $0.spacing = 10
        $0.axis = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        setLayouts()
        setCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.prepare(title: "", image: nil)
    }
    
    func prepare(title: String, image: UIImage?) {
        titleLabel.text = title
        imageView.image = image
    }
    
}

// MARK: - Private Methods

extension SkillListViewCell {
    
    // MARK: - Add View, Set Layout
    
    private func addSubViews() {
        self.contentView.addSubview(horizontalStackView)
        
        [imageView, verticalStackView].forEach { view in
            horizontalStackView.addArrangedSubview(view)
        }
        
        [titleLabel].forEach { view in
            verticalStackView.addArrangedSubview(view)
        }
    }
    
    private func setLayouts() {
        horizontalStackView.snp.makeConstraints { make in
            make.top.left.equalTo(self.contentView).offset(10)
            make.right.bottom.equalTo(self.contentView).offset(-10)
        }
    }
    
    // MARK: - Set Cell Layout
    
    private func setCellLayout() {
        self.contentView.backgroundColor = .white
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: self.contentView.layer.cornerRadius
        ).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
        
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 15
    }
}

