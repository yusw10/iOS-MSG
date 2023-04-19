//
//  ItemSlotView.swift
//  MapleStoryGuide
//
//  Created by cyldev on 2023/03/14.
//

import UIKit

protocol SelectedPartDelegate: AnyObject {
    func selectPart(at: EquipmentPart)
}

final class ItemSlotView: UIView {
    
    weak var viewModel: EuipmentCalcViewModel?
    
    weak var delegate: SelectedPartDelegate?
    
    //MARK: - UIView Properties
    
    var itemSlots: [PartImageView] = []
    
    var mainStackView = UIStackView(frame: .zero).then { UIStackView in
        UIStackView.spacing = 15
        UIStackView.alignment = .center
        UIStackView.distribution = .fillEqually
        UIStackView.axis = .vertical
        UIStackView.backgroundColor = .systemGray2
    }
    
    //MARK: - UIView Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemGray3
        setupLayouts()
        generateItemSlots()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View SetupMethod
    
    private func setupLayouts() {
        addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func generateItemSlots() { // 5개
        
        for row in 0..<6 {
            let stackView = UIStackView().then {
                $0.axis = .horizontal
                $0.alignment = .center
                $0.distribution = .fillEqually
                $0.spacing = 15
                $0.backgroundColor = .systemGray
            }
            
            for column in 0..<5 {
                let part = SlotPartsData[row][column]
                let imageView = PartImageView(frame: .zero, part: part).then { PartImageView in
                    PartImageView.translatesAutoresizingMaskIntoConstraints = false
                    let image = UIImage(systemName: "plus")
                    PartImageView.contentMode = .scaleAspectFill
                    PartImageView.image = image
                    PartImageView.isUserInteractionEnabled = true
                    let slotGesture = ItemSlotTapGesture(target: self, action: #selector(self.itemSlotTapped(_:)))
                    
                    if part != .empty {
                        slotGesture.part = part
                    } else {
                        PartImageView.alpha = 0
                    }
                    PartImageView.addGestureRecognizer(slotGesture)
                    
                }
                
                stackView.addArrangedSubview(imageView)
                itemSlots.append(imageView)
            }
            mainStackView.addArrangedSubview(stackView)
        }
    }
    
    @objc private func itemSlotTapped(_ sender: ItemSlotTapGesture) {
        if (sender.state == .ended) {
            print("터치 이벤트")
            print(sender.part)
            
            delegate?.selectPart(at: sender.part)
        }
    }
}

//MARK: - Equipment Slot Tap Gesture

final class ItemSlotTapGesture: UITapGestureRecognizer {
    var part: EquipmentPart = .empty
}

final class PartImageView: UIImageView {
    var part: EquipmentPart
    
    init(frame: CGRect, part: EquipmentPart) {
        self.part = part
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
