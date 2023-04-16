//
//  ItemSetTagView.swift
//  MapleStoryGuide
//
//  Created by cyldev on 2023/03/14.
//

import UIKit

final class ItemSetTagView: UIScrollView {
    
    private var tagStackView = UIStackView().then { UIStackView in
        UIStackView.distribution = .equalSpacing
        UIStackView.alignment = .leading
        UIStackView.axis = .horizontal
    }
    
    
    //MARK: - UIScrollView Initailizer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemGray4
        setupLayouts()
        
        createTagView(at: EquipmentSet.absolabs, count: 3)
        createTagView(at: EquipmentSet.basicBossAccessory, count: 9)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UIScrollView Setup Method
    
    private func setupLayouts() {
        addSubview(tagStackView)
        
        tagStackView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentLayoutGuide.snp.edges)
        }
    }
    
    private func createTagView(at part: EquipmentSet, count: Int) {
        let tagView = TagView(frame: .zero)
        let title = "\(part) \(count)개"
        tagView.setupTitle(title)
        
        tagStackView.addArrangedSubview(tagView)
    }
}
