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
    private let sideMenuButton = UIButton().then {
        $0.backgroundColor = .secondarySystemBackground
        $0.layer.cornerRadius = 10
        $0.isUserInteractionEnabled = false
        $0.contentHorizontalAlignment = .leading
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .black
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .MapleLightFont()
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
        contentView.addSubview(sideMenuButton)

        sideMenuButton.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(self.contentView).inset(10)

            make.height.equalTo(self.contentView.snp.width).multipliedBy(0.2).priority(750)
        }
    }
    
    func setupCellData(title: String, imageName: String?) {
        sideMenuButton.setTitle(title, for: .normal)
        sideMenuButton.setImage(UIImage(systemName: imageName!) ?? UIImage(), for: .normal)
    }
}

