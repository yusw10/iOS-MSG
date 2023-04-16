//
//  TagView.swift
//  MapleStoryGuide
//
//  Created by cyldev on 2023/03/16.
//

import UIKit

final class TagView: UIView {

    private let label = UILabel().then { UILabel in
        
    }
    
    //MARK: - UIView Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
            
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitle(_ title: String) {
        label.text = title
    }
}
