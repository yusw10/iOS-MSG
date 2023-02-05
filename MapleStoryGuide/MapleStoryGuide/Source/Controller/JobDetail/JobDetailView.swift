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
        collectionViewLayout: self.setCollectionViewSectionLayout()
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
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(10)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-10)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setCollectionView() {
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
    
    private func setCollectionViewSectionLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection? in
            switch self.dataSource[section] {
                
            case .mainImage:
                return self.getLayoutMainImageSection()
            case .link:
                return self.getLayoutLinkSkillSection()
            case .reinforce:
                return self.getLayoutReinforceSection()
            case .matrix:
                return self.getLayoutReinforceSection()
            }
        }
    }
    
    private func getLayoutMainImageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.3)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func getLayoutLinkSkillSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0/8.0)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.2)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func getLayoutReinforceSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 4
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.2)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 8, bottom: -12, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
}
