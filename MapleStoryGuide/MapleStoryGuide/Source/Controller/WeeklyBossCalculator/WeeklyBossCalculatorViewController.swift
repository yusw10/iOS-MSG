//
//  WeeklyBossListViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/16.
//

import UIKit
import SnapKit
import Then

protocol WeelyBossAddViewDelegate: AnyObject {
    
    func weelyBossAdd(from data: MyWeeklyBoss)
    
}

final class WeeklyBossCalculatorViewController: UIViewController, WeelyBossAddViewDelegate {
 
    enum Section: CaseIterable {
        case main
    }
    
    private var viewModel: WeeklyBossCharacterListViewModel
    private var selectedIndex: Int

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
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, MyWeeklyBoss> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewListCell? in
        
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

        var price = object.crystalStonePrice
        if (self.viewModel.selectedCharacter.value?.world.contains("리부트") ?? true) {
            price = object.crystalStonePrice.rebootPrice
        }
        cell.configure(
            bossName: object.name,
            bossDifficulty: object.difficulty,
            bossMember: object.member,
            thumnailImageURL: object.thumnailImageURL,
            bossCrystalStone: price,
            bossClear: object.checkClear
        )
        return cell
    }
    
    init(
        viewModel: WeeklyBossCharacterListViewModel,
        selectedIndex: Int
    ) {
        self.viewModel = viewModel
        self.selectedIndex = selectedIndex
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
        setupLayout()
        
        viewModel.selectedCharacter.subscribe(on: self) { [weak self] information in
            self?.applySnapShot(from: information!)
            self?.applyCrystalStonePrice()
        }
        viewModel.selectCharacter(index: selectedIndex)
        
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applySnapShot(from: self.viewModel.selectedCharacter.value!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        var snapShot = diffableDataSource.snapshot()
        snapShot.deleteAllItems()
        self.diffableDataSource.apply(snapShot)
    }
    
    func weelyBossAdd(from data: MyWeeklyBoss) {
        viewModel.characterInfo.value[selectedIndex].bossInformations.append(data)
        viewModel.selectedCharacter.value?.bossInformations.append(data)
    }

}

private extension WeeklyBossCalculatorViewController {
    
    func setupNavigation() {
        navigationItem.title = viewModel.selectedCharacter.value?.name
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
        guard let indexPath = indexPath else {
            return nil
        }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: deleteActionTitle
        ) { [weak self] _, _, completion in
            self?.viewModel.characterInfo.value[self?.selectedIndex ?? 0].bossInformations.remove(at: indexPath.row)
            self?.viewModel.selectedCharacter.value?.bossInformations.remove(at: indexPath.row)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func applySnapShot(from data: MyCharacter) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MyWeeklyBoss>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data.bossInformations)
        
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func applyCrystalStonePrice() {
        var crystalStonePrice = 0
        
        viewModel.selectedCharacter.value?.bossInformations.forEach({ boss in
            if boss.checkClear == true {
                crystalStonePrice += Int(boss.crystalStonePrice) ?? 0
            }
        })
        
        if (viewModel.selectedCharacter.value?.world.contains("리부트") ?? true) {
            totalPriceLabel.text = crystalStonePrice.description.rebootPrice.insertComma
        } else {
            totalPriceLabel.text = crystalStonePrice.description.insertComma
        }
    }
    
}

@objc private extension WeeklyBossCalculatorViewController {
    
    func onClickSwitch(sender: UISwitch) {
        if sender.isOn {
            viewModel.characterInfo.value[selectedIndex].bossInformations[sender.tag].checkClear = true
            viewModel.selectedCharacter.value?.bossInformations[sender.tag].checkClear = true
        } else {
            viewModel.characterInfo.value[selectedIndex].bossInformations[sender.tag].checkClear = false
            viewModel.selectedCharacter.value?.bossInformations[sender.tag].checkClear = false
        }
    }
    
    func didTapAddBossButton() {
        let weeklyBossAddViewController = WeeklyBossAddViewController(
            characterInfo: viewModel.selectedCharacter.value!
        )
        weeklyBossAddViewController.delegate = self

        navigationController?.pushViewController(weeklyBossAddViewController, animated: true)
    }
    
}
