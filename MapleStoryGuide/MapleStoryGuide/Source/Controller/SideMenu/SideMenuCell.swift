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
    
    let sideMenuMarkImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black
        $0.clipsToBounds = true
    }
    
    let menuTitle = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title3, compatibleWith: .none)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .right
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
        contentView.addSubview(sideMenuMarkImageView)
        contentView.addSubview(menuTitle)
        
        sideMenuMarkImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.trailing.equalTo(menuTitle.snp.leading).offset(5)
            make.width.equalTo(sideMenuMarkImageView.snp.height)
        }
        
        menuTitle.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(5)
            make.trailing.bottom.equalToSuperview().offset(-5)
        })
    }
    
    func setupCellData(title: String, imageName: String?) {
        if let imageName = imageName {
            sideMenuMarkImageView.image = UIImage(systemName: imageName)
            print("?")
        } else {
            sideMenuMarkImageView.image = UIImage(systemName: "staroflife.fill")
        }
        
        menuTitle.text = title
    }
}

