//
//  SideMenuCell.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/02/02.
//

import UIKit
import Then
import SnapKit

final class SideMenuTableViewCell: UITableViewCell {
    
    //MARK: - TableViewCell Properties
    private let sideMenuButtonShadowView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .systemBackground
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    private let sideMenuButton = UIButton().then {
        $0.isUserInteractionEnabled = false
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.configuration = configuration
        
        //UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
        $0.contentHorizontalAlignment = .leading
        $0.setTitleColor(.black, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    //MARK: - TableViewCell Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDefault()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        debugPrint("SideMenuTableViewCell - Initialize Error")
    }
    
    //MARK: - TableViewCell Setup Method
    
    private func setupDefault() {
        contentView.addSubview(sideMenuButtonShadowView)
        
        sideMenuButtonShadowView.addSubview(sideMenuButton)
        
        sideMenuButtonShadowView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.trailing.bottom.equalToSuperview().offset(-10)
        }
        
        sideMenuButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupCellData(title: String, imageName: String?) {
        sideMenuButton.setTitle(title, for: .normal)
        sideMenuButton.setImage(UIImage(systemName: imageName!) ?? UIImage(), for: .normal)
    }
}

