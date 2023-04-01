//
//  WeeklyBossListViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/16.
//

import UIKit
import SnapKit
import Then

// TODO: ViewWillAppear 및 ViewWillDisappear 쪽에 snapshot 코드 수정하기 (TableView로 수정 하고 싶다.)
// TODO: CoreData쪽 연결

final class WeeklyBossCalculatorViewController: UIViewController {
 
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
        $0.delegate = self
    }

    private lazy var totalPriceLabel = UILabel().then {
        $0.font = .preferredFont(
            forTextStyle: .title2,
            compatibleWith: UITraitCollection(legibilityWeight: .bold)
        )
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, MyWeeklyBoss> = .init(collectionView: self.collectionView) { [self] (collectionView, indexPath, object) -> UICollectionViewCell? in
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WeeklyBossCalculatorViewCell.id,
            for: indexPath
        ) as! WeeklyBossCalculatorViewCell
        
        cell.configureCell(name: object.name)
        cell.checkButton.setCheckState(state: object.checkClear)
        cell.checkButton.addTarget(
            self,
            action: #selector(self.didTapCheckButton(sender:)),
            for: .touchUpInside
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
        }
        viewModel.selectCharacter(index: selectedIndex)
        setupNavigation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        var snapShot = diffableDataSource.snapshot()
        snapShot.deleteAllItems()
        self.diffableDataSource.apply(snapShot)
        self.viewModel.selectedCharacter.unsunscribe(observer: self)
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
        self.view.addSubview(collectionView)
    }
    
    func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.view)
        }
    }
    
    func setupCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.08))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func applySnapShot(from data: MyCharacter) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MyWeeklyBoss>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data.bossInformations)
        
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension WeeklyBossCalculatorViewController: WeelyBossAddViewDelegate {
    func weelyBossAdd(from data: WeeklyBossInfo) {
        let data = MyWeeklyBoss(
            checkClear: false,
            name: data.name,
            thumnailImageURL: data.imageURL
        )
        
        viewModel.characterInfo.value[selectedIndex].bossInformations.append(data)
        viewModel.selectedCharacter.value?.bossInformations.append(data)
    }
}

extension WeeklyBossCalculatorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

@objc private extension WeeklyBossCalculatorViewController {
    func didTapAddBossButton() {
        // MARK: Modal 방식으로 변경 (연락처 앱을 확인해보면 뭔가를 추가하는 방식은 대부분 모달 방식으로 동작)
        let weeklyBossAddViewController = WeeklyBossAddViewController()
        weeklyBossAddViewController.delegate = self
        
        present(weeklyBossAddViewController, animated: true)
    }
    
    func didTapCheckButton(sender: CheckBox) {
        if sender.getCheckState() {
            sender.setCheckState(state: false)
        } else {
            sender.setCheckState(state: true)
        }
    }
}
