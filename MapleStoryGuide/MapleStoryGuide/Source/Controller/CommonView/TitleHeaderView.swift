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
    
    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let titleLabel = UILabel().then {
        $0.font = .MapleHeaderFont()
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let screenTransitionButton = UIButton().then {
        $0.titleLabel?.font = .MapleLightFont()
        $0.setTitle("상세보기", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
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
        self.addSubview(horizontalStackView)
        
        [titleLabel, screenTransitionButton].forEach { view in
            horizontalStackView.addArrangedSubview(view)
        }
    }
    
    private func setLayouts() {
        horizontalStackView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-10)
        }
    }
    
}
