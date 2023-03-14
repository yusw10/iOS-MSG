//
//  WeeklyBossCalculatorCollectionViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/11.
//

import UIKit
import SnapKit

final class WeeklyBossCalculatorCollectionViewController: ContentCollectionViewController {
    
    init() {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1))
        )
        item.contentInsets.top = 16
        item.contentInsets.trailing = 16

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(150)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(
            group: group
        )
        section.contentInsets.leading = 16
        
        let layout = UICollectionViewCompositionalLayout(
            section: section
        )
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupCollectionView()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterViewCell.id, for: indexPath)

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
       
}

private extension WeeklyBossCalculatorCollectionViewController {
    
    func setupView() {
        collectionView.backgroundColor = .secondarySystemBackground
    }
    
    func setupCollectionView() {
        collectionView.register(
            CharacterViewCell.self,
            forCellWithReuseIdentifier: CharacterViewCell.id
        )
    }
    
}
