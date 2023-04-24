//
//  WeelyBossAddViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/22.
//

import UIKit
import SnapKit
import Then

final class WeeklyBossAddViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    weak var delegate: WeelyBossAddViewDelegate?
    var myWeeklyBoss: [MyWeeklyBoss]?

    private let repository = LocalWeeklyBossInfoRepository()
    private var viewModel: WeeklyBossAddViewModel! = nil
    private var filterWeeklyBossInfo = [WeeklyBossInfo]()
    
    private let okButton = UIButton().then { button in
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemMint, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.setupCollectionViewLayout()
    ).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.register(
            BossImageCell.self,
            forCellWithReuseIdentifier: BossImageCell.id
        )
    }
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, WeeklyBossInfo> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewListCell? in
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BossImageCell.id,
            for: indexPath
        ) as! BossImageCell
        
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 10
        cell.configureImage(from: object.imageURL)
      
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.okButton.addTarget(
            self,
            action: #selector(didTapOkButton(sender:)),
            for: .touchUpInside
        )
        self.viewModel = WeeklyBossAddViewModel(repository: self.repository)
        setupView()
        setupLayout()
        
        myWeeklyBoss?.forEach({ boss in
            filterWeeklyBossInfo.append(
                WeeklyBossInfo(
                    name: boss.name,
                    imageURL: boss.thumnailImageURL
                )
            )
        })
        Task {
            await viewModel.trigger(query: .weeklyBossInfo)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.bossList.subscribe(on: self) { bossList in
            self.applySnapShot(data: bossList)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.bossList.unsubscribe(observer: self)
    }
    
}

private extension WeeklyBossAddViewController {
    
    func setupView() {
        [okButton, collectionView].forEach { view in
            self.view.addSubview(view)
        }
    }
    
    func setupLayout() {
        okButton.snp.makeConstraints { make in
            make.top.trailing.self.equalToSuperview().inset(10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.okButton.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalTo(self.view)
        }
    }
    
    func setupCollectionViewLayout() -> UICollectionViewCompositionalLayout {
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
        
        return layout
    }
    
    func applySnapShot(data: [WeeklyBossInfo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WeeklyBossInfo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension WeeklyBossAddViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.viewModel.bossList.value[indexPath.row]
       
        let sucessAlertController = UIAlertController(
            title: "성공",
            message: "보스를 추가했습니다.",
            preferredStyle: .alert
        )
        let failureAlertController = UIAlertController(
            title: "실패",
            message: "이미 보스를 추가했습니다.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default)
        
        sucessAlertController.addAction(okAction)
        failureAlertController.addAction(okAction)
        
        // MARK: 로직 변경이 필요해 보임
        if filterWeeklyBossInfo.isEmpty {
            filterWeeklyBossInfo.append(data)
            self.delegate?.weelyBossAdd(from: data)
            present(sucessAlertController, animated: true)
        } else {
            if filterWeeklyBossInfo.contains(where: { $0.name.hasPrefix(data.name)}) {
                present(failureAlertController, animated: true)
            } else {
                filterWeeklyBossInfo.append(data)
                self.delegate?.weelyBossAdd(from: data)
                present(sucessAlertController, animated: true)
            }
        }
    }
    
}

protocol WeelyBossAddViewDelegate: AnyObject {
    func weelyBossAdd(from data: WeeklyBossInfo)
}

@objc private extension WeeklyBossAddViewController {
    func didTapOkButton(sender: UIButton) {
        self.dismiss(animated: true)
    }
}
