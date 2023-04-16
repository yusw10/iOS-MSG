//
//  EquipmentCalcViewController.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/02/05.
//

import UIKit


final class EquipmentCalcViewController: ContentViewController {
    
    //MARK: - ViewController UI Properties
    
    private let equipmentCalcView = EquipmentCalcView(frame: .zero).then { equipmentCalcView in
        
    }
    
    //MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemMint
        setupView()
    }
    
    //MARK: - ViewController Setup Method
    
    private func setupView() {
        view.addSubview(equipmentCalcView)
        
        equipmentCalcView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
