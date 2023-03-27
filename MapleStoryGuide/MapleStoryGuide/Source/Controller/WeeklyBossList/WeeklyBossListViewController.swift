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
    
    private var characterInfo: CharacterInfo?
    private var bossList = [BossInfo]()

    private var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
    )

    private lazy var totalPriceLabel = UILabel().then {
        $0.font = .preferredFont(
            forTextStyle: .title2,
            compatibleWith: UITraitCollection(legibilityWeight: .bold)
        )
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

        if (self.characterInfo?.world?.contains("리부트") ?? true) {
            cell.configure(
                bossName: self.bossList[indexPath.row].name ?? "",
                bossDifficulty: self.bossList[indexPath.row].difficulty ?? "",
                thumnailImageURL: self.bossList[indexPath.row].thumnailImageURL ?? "",
                bossCrystalStone: self.bossList[indexPath.row].crystalStonePrice?.rebootPrice ?? "",
                bossClear: self.bossList[indexPath.row].checkClear
            )
        } else {
            cell.configure(
                bossName: self.bossList[indexPath.row].name ?? "",
                bossDifficulty: self.bossList[indexPath.row].difficulty ?? "",
                thumnailImageURL: self.bossList[indexPath.row].thumnailImageURL ?? "",
                bossCrystalStone: self.bossList[indexPath.row].crystalStonePrice ?? "",
                bossClear: self.bossList[indexPath.row].checkClear
            )
        }
        return cell
    }
    
    init(characterInfo: CharacterInfo) {
        super.init(nibName: nil, bundle: nil)

        self.characterInfo = characterInfo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupCollectionView()
        setupView()
        setupLayout()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applySnapShot()
        applyCrystalStonePrice()
    }

}

private extension WeeklyBossListViewController {
    
    func setupCollectionView() {
        var layoutConfig = UICollectionLayoutListConfiguration(
            appearance: .plain
        )
        layoutConfig.trailingSwipeActionsConfigurationProvider = setupSwipeActions

        let listLayout = UICollectionViewCompositionalLayout.list(
            using: layoutConfig
        )
        collectionView.collectionViewLayout = listLayout
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            WeeklyBossListViewCell.self,
            forCellWithReuseIdentifier: WeeklyBossListViewCell.id
        )
    }
    
    func setupNavigation() {
        navigationItem.title = characterInfo?.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "보스 추가",
            style: .plain,
            target: self,
            action: #selector(didTapAddBossButton)
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
    
    func setupSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath,
              let id = diffableDataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: deleteActionTitle
        ) { [weak self] _, _, completion in
            CoreDatamanager.shared.deleteBoss(id)
            self?.applySnapShot()
            
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func applySnapShot() {
        bossList = CoreDatamanager.shared.readBossList(characterInfo: characterInfo ?? CharacterInfo())
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, BossInfo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(bossList)
        
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func applyCrystalStonePrice() {
        var crystalStonePrice = 0
        
        bossList.forEach({ element in
            if element.checkClear {
                crystalStonePrice += Int(element.crystalStonePrice ?? "0") ?? 0
            }
        })
        if characterInfo!.world!.contains("리부트") {
            totalPriceLabel.text = crystalStonePrice.description.rebootPrice.insertComma
        } else {
            totalPriceLabel.text = crystalStonePrice.description.insertComma
        }
    }
    
}

@objc private extension WeeklyBossListViewController {
    
    func onClickSwitch(sender: UISwitch) {
        if sender.isOn {
            CoreDatamanager.shared.updateBossClear(bossList[sender.tag], clear: true)
        } else {
            CoreDatamanager.shared.updateBossClear(bossList[sender.tag], clear: false)
        }
        applyCrystalStonePrice()
    }
    
    func didTapAddBossButton() {
        let weeklyBossAddViewController = WeeklyBossAddViewController(
            characterInfo: self.characterInfo ?? CharacterInfo()
        )
        
        navigationController?.pushViewController(weeklyBossAddViewController, animated: true)
    }
    
}
