//
//  TitleHeaderView.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/02/02.
//

import UIKit
import SnapKit
import Then

final class TitleHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let id = "TitleHeaderView"
    
    private let verticalStackView = UIStackView().then {
        $0.alignment = .leading
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .secondarySystemBackground
        addSubViews()
        setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.configure(titleText: nil)
    }
    
    func configure(titleText: String?) {
        self.titleLabel.text = titleText
    }
    
}

// MARK: - Private Methods

extension TitleHeaderView {
    
    // MARK: - Add View, Set Layout
    
    private func addSubViews() {
        self.addSubview(verticalStackView)
        
        [titleLabel].forEach { view in
            verticalStackView.addArrangedSubview(view)
        }
    }
    
    private func setLayouts() {
        verticalStackView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-10)
        }
    }
    
}
