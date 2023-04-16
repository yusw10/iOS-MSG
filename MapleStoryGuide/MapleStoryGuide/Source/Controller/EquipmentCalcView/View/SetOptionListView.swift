//
//  setOptionListView.swift
//  MapleStoryGuide
//
//  Created by cyldev on 2023/03/14.
//

import UIKit
import Then

final class SetOptionListView: UIView {
    
    let optionStackView = UIStackView(frame: .zero).then { UIStackView in
        UIStackView.alignment = .fill
        UIStackView.distribution = .fillEqually
        UIStackView.axis = .vertical
    }
    
    //MARK: - View Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemGray5
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Private Method
    
    private func setupLayouts() {
        addSubview(optionStackView)
        
        optionStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
