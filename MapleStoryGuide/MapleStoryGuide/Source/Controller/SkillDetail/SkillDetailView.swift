//
//  SkillDetailView.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/02/02.
//

import UIKit
import SnapKit
import Then

final class SkillDetailView: UIView {
    
    // MARK: - Properties
    
    private let verticalStackView = UIStackView().then {
        $0.spacing = 10
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let descriptionTextView = UITextView().then {
        $0.isEditable = false
        $0.backgroundColor = .secondarySystemBackground
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - initializer
    
    init() {
        super.init(frame: .zero)
        
        addSubViews()
        setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(image: UIImage, title: String, description: String) {
        imageView.image = image
        titleLabel.text = title
        descriptionTextView.text = description
    }
    
}

// MARK: - Private Methods

extension SkillDetailView {
    
    // MARK: - Add View, Set Layout
    
    private func addSubViews() {
        self.addSubview(verticalStackView)
        
        [imageView, titleLabel, descriptionTextView].forEach { view in
            verticalStackView.addArrangedSubview(view)
        }
    }
    
    private func setLayouts() {
        verticalStackView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(self)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(self.snp.width).multipliedBy(0.3)
        }
    }
    
}
