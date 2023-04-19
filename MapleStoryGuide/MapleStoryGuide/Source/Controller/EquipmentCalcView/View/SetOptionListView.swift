//
//  setOptionListView.swift
//  MapleStoryGuide
//
//  Created by cyldev on 2023/03/14.
//

import UIKit
import Then

final class SetOptionListView: UIView {
    
    weak var viewModel: EuipmentCalcViewModel?
    
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
        viewModel?.currentlyApplidOptions.subscribe(on: self, { [self] _ in
            
            guard let optionList = viewModel?.generateSetOpion() else {
                return
            }
            
            generateOptionLabel(optionList: optionList)
        })
        
//        viewModel?.currentlyApplidOptions.value = [EquipmentSetOption(equipmentSetOptionSet: "아케인셰이드", options: [SetOption(setCount: "2", option: [Option(optionName: "보스공격력", optionAmount: 20)])])]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Private Method
    
    private func setupLayouts() {
        addSubview(optionStackView)
        
        optionStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func generateOptionLabel(optionList: [String: Int]) {
        //변경시 일단 옵션 목록 다 비우고
        optionStackView.subviews.forEach { UIView in
            optionStackView.removeArrangedSubview(UIView)
        }
        
        optionList.forEach { (key: String, value: Int) in
            let text = "\(key) : \(value)"
            let label = UILabel(frame: .zero)
            label.sizeToFit()
            label.text = text
            label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .none)
            optionStackView.addArrangedSubview(label)
            print(optionStackView.subviews.count)
        }
    }
}

/*
 
 struct EquipmentSetOption {
     let equipmentSetOptionSet: String
     let options: [SetOption]
 }

 struct SetOption {
     let setCount: String
     let option: [Option]
 }

 struct Option {
     let optionName: String
     let optionAmount: String
     
     func toString() -> String {
         return "\(optionName) : \(optionName.contains("%") ? "\(optionAmount)%" : "\(optionAmount)")"
     }
 }

 */

/*
 enum SetOptions: Codable {
 case atkAndMtk //공격력 및 마력
 case bossAtkDamage //보스 몬스터 공격시 데미지
 case allStat //올스탯
 case maxHp //최대 HP
 case maxMp //최대 MP
 case maxHpRate //최대 HP%
 case maxMpRate //최대 MP%
 case defenseIgnore //몬스터 방어율 무시
 case defense //방어력
 case criticalHitRate //크리티컬 데미지
 }
 */
