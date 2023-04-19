//
//  ItemSetTagView.swift
//  MapleStoryGuide
//
//  Created by cyldev on 2023/03/14.
//

import UIKit

final class ItemSetTagView: UIScrollView {
    
    weak var viewModel: EuipmentCalcViewModel?
    
    var tagStackView = UIStackView().then { UIStackView in
        UIStackView.distribution = .equalSpacing
        UIStackView.alignment = .leading
        UIStackView.axis = .horizontal
    }
    
    
    //MARK: - UIScrollView Initailizer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemGray4
        setupLayouts()
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
    
    func resetTagView() {
        self.tagStackView.arrangedSubviews.forEach { UIView in
            UIView.removeFromSuperview()
        }
    }
    
    func createTagView(at part: EquipmentSet, count: Int) {
        let tagView = TagView(frame: .zero)
        let title = "\(part) \(count)개"
        tagView.setupTitle(title)
        
        tagStackView.addArrangedSubview(tagView)
    }
}
