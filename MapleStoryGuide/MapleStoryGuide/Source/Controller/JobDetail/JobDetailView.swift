//
//  JobDetailView.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/02/05.
//

import UIKit
import SnapKit
import Then

final class JobDetailView: UIView {
    
    // MARK: - Properties

    private var dataSource = MockData.dataSource
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    )
    
    // MARK: - initializer

    init() {
        super.init(frame: .zero)
        
        addSubViews()
        setLayouts()
        setCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Methods

extension JobDetailView {
    
    // MARK: - Add View, Set Layout

    private func addSubViews() {
        self.addSubview(collectionView)
    }
    
    private func setLayouts() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setCollectionView() {
        
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)

        listConfiguration.headerMode = .supplementary
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
        collectionView.collectionViewLayout = listLayout
        
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.clipsToBounds = true
        
        collectionView.register(
            JobImageViewCell.self,
            forCellWithReuseIdentifier: JobImageViewCell.id
        )
        collectionView.register(
            SkillListViewCell.self,
            forCellWithReuseIdentifier: SkillListViewCell.id
        )
        collectionView.register(
            TitleHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeaderView.id
        )
    }

    
}
