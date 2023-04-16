//
//  ItemSlotView.swift
//  MapleStoryGuide
//
//  Created by cyldev on 2023/03/14.
//

import UIKit

final class ItemSlotView: UIView {
    
    //MARK: - UIView Properties
    
    private var itemSlots: [UIStackView] = []
    
    private var mainStackView = UIStackView(frame: .zero).then { UIStackView in
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
                let imageView = UIImageView(frame: .zero).then { UIImageView in
                    UIImageView.translatesAutoresizingMaskIntoConstraints = false
                    let image = UIImage(named: "testEqupmentImage")
                    //UIImageView.contentMode = .scaleAspectFill
                    UIImageView.image = image
                    UIImageView.isUserInteractionEnabled = true
                    let slotGesture = ItemSlotTapGesture(target: self, action: #selector(self.itemSlotTapped(_:)))
                    let part = SlotPartsData[row][column]
                    if part != .empty {
                        slotGesture.part = part
                    } else {
                        UIImageView.alpha = 0
                    }
                    UIImageView.addGestureRecognizer(slotGesture)
                    
                }
                
                stackView.addArrangedSubview(imageView)
            }
            mainStackView.addArrangedSubview(stackView)
            itemSlots.append(stackView)
        }
    }
    
    @objc private func itemSlotTapped(_ sender: ItemSlotTapGesture) {
        if (sender.state == .ended) {
            print("터치 이벤트")
            print(sender.part)
        }
    }
}

//MARK: - Equipment Slot Tap Gesture

final class ItemSlotTapGesture: UITapGestureRecognizer {
    var part: EquipmentPart = .empty
}

let SlotPartsData: [[EquipmentPart]] = [
    [.ring, .empty, .head, .empty, .emblem],
    [.ring, .necklace, .eyeMask, .empty, .title],
    [.ring, .necklace, .faceMask, .earring, .badge],
    [.ring, .weapon, .top, .shoulder, .subWeapon],
    [.pocket, .belt, .pants, .glove, .cloak],
    [.empty, .empty, .shoes, .android, .heart]
]
