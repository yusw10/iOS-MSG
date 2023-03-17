//
//  WeeklyBossListViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/16.
//

import UIKit
import SnapKit
import Then

final class WeeklyBossListViewController: UIViewController {
    
    var charcter = CharacterInfo()
    
    private var collectionView: UICollectionView!

    private lazy var totalPriceLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "총 가격:"
        $0.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupView()
        setupLayout()
    }
    
    func configure(with charcter: CharacterInfo) {
        navigationItem.title = charcter.name
        totalPriceLabel.text = charcter.totalRevenue
        
        self.charcter = charcter
    }
    
}

extension WeeklyBossListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WeeklyBossListViewCell.id,
            for: indexPath
        ) as! WeeklyBossListViewCell
        
        cell.clearCheckSwitch.addTarget(
            self,
            action: #selector(onClickSwitch(sender:)),
            for: UIControl.Event.valueChanged
        )

        return cell
    }
    
}

private extension WeeklyBossListViewController {
    
    func setupCollectionView() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: setupCollectionViewLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.backgroundColor = .secondarySystemBackground
        
        collectionView.register(
            WeeklyBossListViewCell.self,
            forCellWithReuseIdentifier: WeeklyBossListViewCell.id
        )
    }
    
    func setupView() {
        [collectionView, totalPriceLabel].forEach { view in
            self.view.addSubview(view)
        }
    }
    
    func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(totalPriceLabel.snp.top)
        }
        
        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.view)
            
            make.height.equalTo(self.view.snp.width).multipliedBy(0.2)
        }
    }
    
    func setupCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.25))
        )
        item.contentInsets.trailing = 16

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(120)
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
        
        return layout
    }
    
    @objc func onClickSwitch(sender: UISwitch) {
        if sender.isOn {
            CoreDatamanager.shared.update(charcter, inform: "3")
        } else {
            CoreDatamanager.shared.update(charcter, inform: "2")
        }
    }
   
    
}
