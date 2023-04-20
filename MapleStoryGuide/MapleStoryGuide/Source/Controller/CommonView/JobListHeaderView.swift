//
//  JobListHeaderView.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/02/06.
//

import UIKit
import Then
import SnapKit

final class JobListHeaderView: UICollectionReusableView {
    
    //MARK: - JobList HeaderView Properites
    
    private let titleLabel = UILabel().then { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .MapleHeaderFont()
    }
    
    //MARK: - JobList HeaderView Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    //MARK: - JobList HeaderView Setup Method
    
    private func setupHeaderView() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.snp.leading).offset(20)
        }
    }
    
    //MARK: - Data Setup method
    
    func setupTitle(title: String) {
        titleLabel.text = title
    }
}
