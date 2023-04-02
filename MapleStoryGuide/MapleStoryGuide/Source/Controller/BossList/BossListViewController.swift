//
//  BossListViewController.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/03/15.
//

import UIKit
import SnapKit
import Then

class BossListViewController: ContentViewController, UICollectionViewDelegate {
    
    enum Section: Int {
        case gridSection
    }
    
    private var indexPath = 0
    private let repository = LocalBossInfoRepository()
    private var viewModel: BossInfoViewModel! = nil
    
    private let bossGridView = BossListView()
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, BossInfo> = .init(
        collectionView: self.bossGridView.collectionView)
    { (collectionView, indexPath, object) -> UICollectionViewCell in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BossImageCell.id, for: indexPath) as? BossImageCell else { return UICollectionViewCell() }
        
        let imageURL = object.imageURL
        cell.configureImage(from: imageURL)
        
        return cell
    }
    
    override func loadView() {
        super.loadView()

        self.view = bossGridView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "보스 리스트"
        bossGridView.collectionView.delegate = self
        viewModel = BossInfoViewModel(repository: self.repository)
        self.subscribeViewModel()
        
        Task {
            await viewModel.trigger(query: .bossJson)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            viewModel.bossListInfo.unsubscribe(observer: self)
        }
    }
    
    private func subscribeViewModel() {
        viewModel.bossListInfo.subscribe(on: self) { bossList in
            self.applySnapshot(from: bossList)
        }
    }
    
    private func applySnapshot(from data: [BossInfo]) {
        var snapshot = self.diffableDataSource.snapshot()
        snapshot.appendSections([.gridSection])
        snapshot.appendItems(data)
        
        diffableDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bossDetailViewController = BossDetailViewController(viewModel: self.viewModel)
        bossDetailViewController.selectDelegate = self
        self.indexPath = indexPath.row
        self.containerViewController?.pushViewController(bossDetailViewController)
    }
}

extension BossListViewController: BossDetailViewDelegate {
    func selectBoss() {
        self.viewModel.selectBoss(indexPath)
    }
}

// BossListView
class BossListView: UIView {
    let collectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.25)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            BossImageCell.self,
            forCellWithReuseIdentifier: BossImageCell.id
        )
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        self.addSubview(self.collectionView)
    }
    
    private func setLayout() {
        self.collectionView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
    }
}
