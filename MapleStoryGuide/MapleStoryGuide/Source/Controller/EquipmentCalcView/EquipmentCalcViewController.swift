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
    
    private var currentEquipedPart = [[Part]]()
    private var currentlyApplidOptions = [EquipmentSetOption]()
    
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
        
        viewModel.currentlyApplidOptions.subscribe(on: self) { [weak self] _ in
            guard let self = self else { return }
            self.currentlyApplidOptions = self.viewModel.currentlyApplidOptions.value
        }
        
        Task {
            
            await viewModel.triggerSet(query:.equipmentSet)
            await viewModel.triggerPart(query: .equipmentPart)
        }
        /*
         viewModel = JobInfoViewModel(repository: repository)
         viewModel.jobListInfo.subscribe(on: self) { [self] _ in
             self.jobList = viewModel.fetchJobGroup()
             
             DispatchQueue.main.async {
                 self.jobListCollectionView.reloadData()
             }
         }
         
         Task {
             await viewModel.trigger(query: .newJson)
         }
         */
    }
    
    //MARK: - ViewController Setup Method
    
    private func setupView() {
        view.addSubview(equipmentCalcView)
        equipmentCalcView.viewModel = self.viewModel
        
        equipmentCalcView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}


extension EquipmentCalcViewController: SelectedPartDelegate {
    func selectPart(at: EquipmentPart) {
        let parts = viewModel.selectPart(at: at)
        
        let alert = UIAlertController(title: "", message: "부위를 선택해주세요.", preferredStyle: .alert)
        parts.forEach { Part in
            let action = UIAlertAction(title: "\(Part.name)", style: .default) { _ in
                print("현재 \(Part.name)")
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
