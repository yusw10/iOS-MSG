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
    
    private let containerView = UIView().then { view in
        view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9).cgColor
        view.layer.cornerRadius = 7
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let titleLabel = UILabel().then { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
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
        addSubview(containerView)
        self.containerView.addSubview(titleLabel)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.containerView.snp.leading).offset(10)
        }
    }
    
    //MARK: - Data Setup method
    
    func setupTitle(title: String) {
        titleLabel.text = title
    }
}
