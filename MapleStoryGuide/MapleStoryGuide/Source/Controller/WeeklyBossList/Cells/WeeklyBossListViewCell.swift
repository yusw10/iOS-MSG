//
//  WeeklyBossListViewCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/16.
//

import UIKit
import SnapKit
import Then

final class WeeklyBossListViewCell: UICollectionViewCell {
    
    static let id = "WeeklyBossListViewCell"
    
    private lazy var horizontalStackView = UIStackView().then {
        $0.alignment = .center
        $0.spacing = 10
        $0.axis = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var thumbnailImageView = UIImageView().then {
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.backgroundColor = .red
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var bossLevel = UILabel().then {
        $0.text = "난이도: Normal"
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var bossCrystalStone = UILabel().then {
        $0.text = "결정석: 100"
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var verticalStackView = UIStackView().then {
        $0.spacing = 10
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var clearCheckSwitch = UISwitch().then {
        $0.addTarget(self, action: #selector(onClickSwitch(sender:)), for: UIControl.Event.valueChanged)

        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension WeeklyBossListViewCell {
    
    func setupView() {
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(horizontalStackView)
        
        [thumbnailImageView, verticalStackView, clearCheckSwitch].forEach { view in
            horizontalStackView.addArrangedSubview(view)
        }
        
        [bossLevel, bossCrystalStone].forEach { view in
            verticalStackView.addArrangedSubview(view)
        }
    }
    
    func setupLayout() {
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.contentView).inset(10)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.3)
            make.height.equalTo(self.contentView.snp.width).multipliedBy(0.2)
        }
        
        clearCheckSwitch.snp.makeConstraints { make in
            make.trailing.equalTo(horizontalStackView.snp.trailing)
        }
    }
    
    @objc func onClickSwitch(sender: UISwitch) {
        if sender.isOn {
            print("on")
        } else {
            print("off")
        }
    }
    
}
