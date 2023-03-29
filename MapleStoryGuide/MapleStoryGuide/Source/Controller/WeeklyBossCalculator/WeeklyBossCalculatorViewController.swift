//
//  WeeklyBossListViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/16.
//

import UIKit
import SnapKit
import Then

final class WeeklyBossCalculatorViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    private var viewModel: WeeklyBossCalculatorViewModel! = nil
    private var characterInfo: CharacterInfo?
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.setupCollectionViewLayout()
    ).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(
            WeeklyBossCalculatorViewCell.self,
            forCellWithReuseIdentifier: WeeklyBossCalculatorViewCell.id
        )
    }

    private lazy var totalPriceLabel = UILabel().then {
        $0.font = .preferredFont(
            forTextStyle: .title2,
            compatibleWith: UITraitCollection(legibilityWeight: .bold)
        )
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, BossInformation> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewListCell? in
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WeeklyBossCalculatorViewCell.id,
            for: indexPath
        ) as! WeeklyBossCalculatorViewCell
        
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
                bossName: self.viewModel.bossInformation.value[indexPath.row].name ?? "",
                bossDifficulty: self.viewModel.bossInformation.value[indexPath.row].difficulty ?? "",
                bossMember: self.viewModel.bossInformation.value[indexPath.row].member ?? "",
                thumnailImageURL: self.viewModel.bossInformation.value[indexPath.row].thumnailImageURL ?? "",
                bossCrystalStone: self.viewModel.bossInformation.value[indexPath.row].crystalStonePrice?.rebootPrice ?? "",
                bossClear: self.viewModel.bossInformation.value[indexPath.row].checkClear
            )
        } else {
            cell.configure(
                bossName: self.viewModel.bossInformation.value[indexPath.row].name ?? "",
                bossDifficulty: self.viewModel.bossInformation.value[indexPath.row].difficulty ?? "",
                bossMember: self.viewModel.bossInformation.value[indexPath.row].member ?? "",
                thumnailImageURL: self.viewModel.bossInformation.value[indexPath.row].thumnailImageURL ?? "",
                bossCrystalStone: self.viewModel.bossInformation.value[indexPath.row].crystalStonePrice ?? "",
                bossClear: self.viewModel.bossInformation.value[indexPath.row].checkClear
            )
        }
        return cell
    }
    
    init(characterInfo: CharacterInfo) {
        super.init(nibName: nil, bundle: nil)

        self.characterInfo = characterInfo
        viewModel = WeeklyBossCalculatorViewModel(characterInfo: characterInfo)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
        setupLayout()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.bossInformation.subscribe(on: self) { [weak self] bossInformation in
            self?.applySnapShot(from: bossInformation)
        }
        viewModel.fetchBossInformation()
        
        applyCrystalStonePrice()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.bossInformation.unsunscribe(observer: self)
    }

}

private extension WeeklyBossCalculatorViewController {
    
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
    
    func setupCollectionViewLayout() -> UICollectionViewLayout {
        var layoutConfig = UICollectionLayoutListConfiguration(
            appearance: .plain
        )
        layoutConfig.trailingSwipeActionsConfigurationProvider = setupSwipeActions
        
        let listLayout = UICollectionViewCompositionalLayout.list(
            using: layoutConfig
        )
        
        return listLayout
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
            self?.viewModel.deleteBossInformation(id: id)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func applySnapShot(from data: [BossInformation]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, BossInformation>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func applyCrystalStonePrice() {
        var crystalStonePrice = 0
        
        viewModel.bossInformation.value.forEach({ element in
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

@objc private extension WeeklyBossCalculatorViewController {
    
    func onClickSwitch(sender: UISwitch) {
        if sender.isOn {
            viewModel.updateBossClear(
                bossInformation: viewModel.bossInformation.value[sender.tag],
                clear: true
            )
        } else {
            viewModel.updateBossClear(
                bossInformation: viewModel.bossInformation.value[sender.tag],
                clear: false
            )
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
