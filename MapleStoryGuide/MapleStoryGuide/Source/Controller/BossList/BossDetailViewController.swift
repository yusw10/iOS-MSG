//
//  BossDetailViewController.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/03/16.
//

import UIKit
import SnapKit
import Then

enum BossDetailSection: Int, CaseIterable {
    case imageSection
    case levelSection
    case forceSection
    case rewardPriceSection
    case rewardItemSection
}

class BossDetailViewController: ContentViewController {
    //MARK: property
    private let viewModel: BossInfoViewModel
    weak var selectDelegate: BossDetailViewDelegate?
    
    //MARK: View
    private let bossDetailView = BossDetailView()
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<BossDetailSection, AnyHashable> = .init(
        collectionView: self.bossDetailView.collectionView
    ) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell in
        if let object = itemIdentifier as? String {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainBossImageCell.id, for: indexPath) as! MainBossImageCell
            cell.configureImage(from: object)
            
            return cell
        } else if let object = itemIdentifier as? ModeLevel {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LevelAndForceCell.id, for: indexPath) as! LevelAndForceCell
            cell.configureCell(mode: object.mode, info: object.level)
            
            return cell
        } else if let object = itemIdentifier as? ModeForce {
            if object.mode == "nil" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCell.id, for: indexPath) as! DescriptionCell
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LevelAndForceCell.id, for: indexPath) as! LevelAndForceCell
                cell.configureCell(mode: object.mode, info: object.force)
                
                return cell
            }
        } else if let object = itemIdentifier as? RewardPrice {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RewardPriceCell.id, for: indexPath) as! RewardPriceCell
            cell.configureCell(mode: object.mode, price: object.price)
            
            return cell
        } else if let object = itemIdentifier as? RewardItem {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RewardItemCell.id, for: indexPath) as! RewardItemCell
            cell.configureCell(imageURL: object.imageURL, name: object.name)
            
            return cell
        } else {
            fatalError("Unknown Cell")
        }
    }
    
    init(viewModel: BossInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = bossDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setHeaderView()
        self.subscribeViewModel()
        selectDelegate?.selectBoss()
        self.configureNav()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.isMovingFromParent {
            var snapshot = self.diffableDataSource.snapshot()
            snapshot.deleteAllItems()
            diffableDataSource.apply(snapshot, animatingDifferences: false)
            viewModel.bossInfo.unsubscribe(observer: self)
        }
    }
    
    private func configureNav() {
        self.navigationItem.title = viewModel.bossInfo.value?.name
    }
    
    private func subscribeViewModel() {
        self.viewModel.bossInfo.subscribe(on: self) { info in
            guard let info = info else { return }
            self.applySnapshot(from: info)
        }
    }
    
    private func applySnapshot(from info: BossInfo) {
        var snapshot = NSDiffableDataSourceSnapshot<BossDetailSection, AnyHashable>()
        
        if let force = info.force {
            snapshot.appendSections(BossDetailSection.allCases)
            snapshot.appendItems([info.imageURL], toSection: .imageSection)
            snapshot.appendItems(info.level, toSection: .levelSection)
            snapshot.appendItems(force.modeForce, toSection: .forceSection)
            snapshot.appendItems(info.rewardPrice, toSection: .rewardPriceSection)
            snapshot.appendItems(info.rewardItem, toSection: .rewardItemSection)
            
            diffableDataSource.apply(snapshot, animatingDifferences: false)
        } else {
            snapshot.appendSections(BossDetailSection.allCases)
            snapshot.appendItems([info.imageURL], toSection: .imageSection)
            snapshot.appendItems(info.level, toSection: .levelSection)
            snapshot.appendItems([ModeForce(mode: "nil", force: 0)], toSection: .forceSection)
            snapshot.appendItems(info.rewardPrice, toSection: .rewardPriceSection)
            snapshot.appendItems(info.rewardItem, toSection: .rewardItemSection)
            
            diffableDataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    private func setHeaderView() {
        diffableDataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            guard elementKind == UICollectionView.elementKindSectionHeader else { return nil }
            
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind,
                withReuseIdentifier: TitleHeaderView.id,
                for: indexPath
            ) as! TitleHeaderView
            
            let snapshot = self.diffableDataSource.snapshot()
            let section = snapshot.sectionIdentifiers[indexPath.section]
            
            if section == .imageSection {
                header.screenTransitionButton.isHidden = true
            } else if section == .levelSection {
                header.configure(titleText: "레벨")
                header.screenTransitionButton.isHidden = true
            } else if section == .forceSection {
                if self.viewModel.bossInfo.value?.force == nil {
                    header.configure(titleText: "포스")
                } else {
                    header.configure(titleText: self.viewModel.bossInfo.value?.force?.type)
                }
                
                header.screenTransitionButton.isHidden = true
            } else if section == .rewardPriceSection {
                header.configure(titleText: "결정석 가격")
                header.screenTransitionButton.isHidden = true
            } else if section == .rewardItemSection {
                header.configure(titleText: "주요 보상")
                header.screenTransitionButton.addTarget(
                    self,
                    action: #selector(self.tapAction),
                    for: .touchUpInside
                )
            }
            
            return header
        }
    }
    
    @objc private func tapAction() {
        let itemDetailViewController = ItemDetailViewController(viewModel: self.viewModel)
        containerViewController?.pushViewController(itemDetailViewController)
    }
}

protocol BossDetailViewDelegate: AnyObject {
    func selectBoss()
}

// MARK: BossDetailView
class BossDetailView: UIView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then { collectionView in
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCollectionView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollectionView() {
        self.collectionView.collectionViewLayout = createLayout()
        
        self.collectionView.register(MainBossImageCell.self, forCellWithReuseIdentifier: MainBossImageCell.id)
        self.collectionView.register(LevelAndForceCell.self, forCellWithReuseIdentifier: LevelAndForceCell.id)
        self.collectionView.register(DescriptionCell.self, forCellWithReuseIdentifier: DescriptionCell.id)
        self.collectionView.register(RewardPriceCell.self, forCellWithReuseIdentifier: RewardPriceCell.id)
        self.collectionView.register(RewardItemCell.self, forCellWithReuseIdentifier: RewardItemCell.id)
        self.collectionView.register(
            TitleHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeaderView.id
        )
    }
    
    private func setLayout() {
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self  = self else { return nil}
            
            let sectionKind = BossDetailSection(rawValue: sectionIndex)
            let section: NSCollectionLayoutSection
            
            if sectionKind == .imageSection {
                section = self.createImageSection()
            } else if sectionKind == .levelSection {
                section = self.createLevelAndForceSection()
            } else if sectionKind == .forceSection {
                section = self.createLevelAndForceSection()
            } else if sectionKind == .rewardPriceSection {
                section = self.createPriceListSection()
            } else if sectionKind == .rewardItemSection {
                section = self.createItemListSection()
            } else {
                fatalError("Unknown Section!")
            }
            
            return section
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 15
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: configuration)
    }
    
    private func createImageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    // MARK: Section 별로 headerSize를 추가하고 header를 section의 supplementaryItem에 추가하면 정상적으로 Section Header를 추가할 수 있다.
    private func createLevelAndForceSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.31), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.06))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.04))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createPriceListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.05))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        section.interGroupSpacing = 5
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.04))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func createItemListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.08))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        section.interGroupSpacing = 10
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.04))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        return section
    }
}
