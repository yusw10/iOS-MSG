//
//  EquipmentCalcViewController.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/02/05.
//

import UIKit


final class EquipmentCalcViewController: ContentViewController {
    
    //MARK: - ViewController Properties
    
    private let repository = AssetEuipmentCalcRepository()
    private var viewModel: EuipmentCalcViewModel! = nil
    
    private var currentEquipedPart = [[EquipmentPart: Part]]()
    private var currentlyApplidOptions = [EquipmentSet: Int]()
    
    //MARK: - ViewController UI
    
    private let equipmentCalcView = EquipmentCalcView(frame: .zero).then { equipmentCalcView in
        
    }
    
    //MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        equipmentCalcView.itemSlotView.delegate = self
        
        view.backgroundColor = .systemMint
        setupView()
        
        viewModel = EuipmentCalcViewModel(repository: repository)
        equipmentCalcView.setOptionListView.viewModel = viewModel
        equipmentCalcView.itemSetTagView.viewModel = viewModel
        equipmentCalcView.itemSlotView.viewModel = viewModel
        equipmentCalcView.viewModel = viewModel
        
        viewModel.currentlyEquipedPartInfo.subscribe(on: self) { [weak self] equipedPartInfo in
            guard let self = self else { return }
            // 장착 장비 변경
            equipedPartInfo.forEach { (key: EquipmentPart, value: Part) in
                print(self.equipmentCalcView.itemSlotView.itemSlots.count)
                self.equipmentCalcView.itemSlotView.itemSlots.forEach { PartImageView in
                    if key == PartImageView.part {
                        Task {
                            PartImageView.image = nil
                            await PartImageView.fetchImage(value.imageURL)
                            print("test")
                        }
                    }
                }
                self.viewModel.updateCurrentlyAppliedSetOption()
                
            }
            // 변경에 따른 옵션의 변동
        }
        viewModel.currentlyApplidOptions.subscribe(on: self, { currentlyAppliedOptionList in
            print("*****")
            print(currentlyAppliedOptionList)
            self.equipmentCalcView.itemSetTagView.resetTagView()
            currentlyAppliedOptionList.forEach { (key: EquipmentSet, value: Int) in
                Task {
                    
                    self.equipmentCalcView.itemSetTagView.createTagView(at: key, count: value)
                }
            }
        })
        
        Task {
            await viewModel.triggerSet(query:.equipmentSet)
            await viewModel.triggerPart(query: .equipmentPart)
        }
    }
    
    //MARK: - ViewController Setup Method
    
    private func setupView() {
        view.addSubview(equipmentCalcView)
        equipmentCalcView.viewModel = self.viewModel
        
        equipmentCalcView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func selectPartToEquiped(at selectedPart: EquipmentPart, to selectedEquipment: Part) {
        viewModel.addEquipedPart(at: selectedPart, to: selectedEquipment)
    }
}


extension EquipmentCalcViewController: SelectedPartDelegate {
    func selectPart(at: EquipmentPart) {
        let parts = viewModel.selectPart(at: at)
        
        let alert = UIAlertController(title: "", message: "부위를 선택해주세요.", preferredStyle: .alert)
        parts.forEach { Part in
            let action = UIAlertAction(title: "\(Part.name)", style: .default) { _ in
                print("\(Part.name) 선택 !")
                self.selectPartToEquiped(at: at, to: Part)
            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "취소", style: .destructive))
        self.present(alert, animated: true)
    }
}
/*
 1. 최초 로딩시
    1.1 파츠 목록 불러오기
    1.2 세트옵션 리스트 불러오기
    1.3 빈 파츠 배열 연결
    1.4 빈 세트옵션 배열 연결
 */
