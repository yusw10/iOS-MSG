//
//  EquipMentCalcView.swift
//  MapleStoryGuide
//
//  Created by cyldev on 2023/03/14.
//

import UIKit

final class EquipmentCalcView: UIScrollView {
    
    //MARK: - UI Properties
    
    private let contentView = UIView(frame: .zero).then { UIView in
        
    }
    
    private let itemSlotView = ItemSlotView(frame: .zero).then { ItemSlotView in
        ItemSlotView.backgroundColor = .green
        ItemSlotView.layer.cornerRadius = 10
    }
    
    private let itemSetTagView = ItemSetTagView(frame: .zero).then { ItemSetTagView in
        ItemSetTagView.layoutIfNeeded()
    }
    
    private let setOptionListView = SetOptionListView(frame: .zero).then { SetOptionListView in
        
    }
    
    //MARK: - UIView Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        showsVerticalScrollIndicator = false
        addUIProperties()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Setup Method
    
    private func addUIProperties() {
        addSubview(contentView)
        contentView.addSubview(itemSlotView)
        contentView.addSubview(itemSetTagView)
        contentView.addSubview(setOptionListView)
    }
    
    private func setupLayouts() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self.snp.width)
        }
        
        itemSlotView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }
        
        itemSetTagView.snp.makeConstraints { make in
            make.top.equalTo(itemSlotView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(50)
        }
        
        setOptionListView.snp.makeConstraints { make in
            make.top.equalTo(itemSetTagView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}
