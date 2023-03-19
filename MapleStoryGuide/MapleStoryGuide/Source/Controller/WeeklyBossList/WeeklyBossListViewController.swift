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
    
    enum Section: CaseIterable {
        case main
    }
    
    private var bossList = [BossInfo]()
    private var characterInfo: CharacterInfo?
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.setupCollectionViewLayout()
    ).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .secondarySystemBackground
        $0.register(
            WeeklyBossListViewCell.self,
            forCellWithReuseIdentifier: WeeklyBossListViewCell.id
        )
    }

    private lazy var totalPriceLabel = UILabel().then {
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, BossInfo> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewListCell? in
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WeeklyBossListViewCell.id,
            for: indexPath
        ) as! WeeklyBossListViewCell
        
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 15
        
        cell.clearCheckSwitch.addTarget(
            self,
            action: #selector(self.onClickSwitch(sender:)),
            for: UIControl.Event.valueChanged
        )
        cell.clearCheckSwitch.tag = indexPath.row

        cell.configure(
            bossLevel: self.bossList[indexPath.row].name ?? "",
            bossCrystalStone: self.bossList[indexPath.row].crystalStonePrice ?? "",
            bossClear: self.bossList[indexPath.row].checkClear
        )
        return cell
    }
    
    init(characterInfo: CharacterInfo) {
        self.characterInfo = characterInfo
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
        setupLayout()
        setupNavigation()
        
        updateSnapShot()
        updateLabel()
    }

    func updateLabel() {
        var myPrice = 0
        
        bossList.forEach({ element in
            if element.checkClear {
                myPrice += Int(element.crystalStonePrice ?? "0") ?? 0
            }
        })
        totalPriceLabel.text = myPrice.description
    }

}

private extension WeeklyBossListViewController {
    
    func setupNavigation() {
        navigationItem.title = characterInfo?.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "보스 추가",
            style: .plain,
            target: self,
            action: #selector(addTapped)
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
    
    func updateSnapShot() {
        bossList = CoreDatamanager.shared.readBossList(characterInfo: characterInfo ?? CharacterInfo())
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, BossInfo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(bossList)
        
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func onClickSwitch(sender: UISwitch) {
        if sender.isOn {
            CoreDatamanager.shared.updateBossClear(bossList[sender.tag], clear: true)
        } else {
            CoreDatamanager.shared.updateBossClear(bossList[sender.tag], clear: false)
        }
        updateLabel()
    }
    
    @objc func addTapped() {
        CoreDatamanager.shared.createBoss(
            name: "테스트 입니다.",
            price: "10000",
            character: characterInfo ?? CharacterInfo()
        )
        updateSnapShot()
    }
    
}


