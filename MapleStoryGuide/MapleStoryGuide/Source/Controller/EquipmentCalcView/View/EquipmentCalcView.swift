//
//  EquipMentCalcView.swift
//  MapleStoryGuide
//
//  Created by cyldev on 2023/03/14.
//

import UIKit

final class EquipmentCalcView: UIScrollView {
    
    //MARK: - Properties
    
    weak var viewModel: EuipmentCalcViewModel?
    
    //MARK: - UI Properties
    
    let itemSlotView = ItemSlotView(frame: .zero).then { ItemSlotView in
        ItemSlotView.backgroundColor = .green
        ItemSlotView.layer.cornerRadius = 10
    }
    
    let itemSetTagView = ItemSetTagView(frame: .zero).then { ItemSetTagView in
        ItemSetTagView.layoutIfNeeded()
    }
    
    let setOptionListView = SetOptionListView(frame: .zero).then { SetOptionListView in
        SetOptionListView.backgroundColor = .brown
    }
    
    //MARK: - UIView Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        showsVerticalScrollIndicator = false
        addUIProperties()
        setupLayouts()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Setup Method
    
    private func addUIProperties() {
        addSubview(itemSlotView)
        addSubview(itemSetTagView)
        addSubview(setOptionListView)
    }
    
    private func setupLayouts() {
        
        itemSlotView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalTo(itemSlotView.snp.width)
        }
        
        itemSetTagView.snp.makeConstraints { make in
            make.top.equalTo(itemSlotView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        setOptionListView.snp.makeConstraints { make in
            make.top.equalTo(itemSetTagView.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
