//
//  WeelyBossAddViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/22.
//

import UIKit
import SnapKit
import Then

struct BossList: Hashable {
    let name: String
    let thumnailImageURL: String
    let difficulty: [String]
    let price: [String]
}

final class WeeklyBossAddViewController: UIViewController {
    
    var characterInfo: CharacterInfo?

    private let bossList = [
        BossList(name: "스우",
                 thumnailImageURL: "https://raw.githubusercontent.com/yusw10/iOS-MSG-Data/main/%E1%84%87%E1%85%A9%E1%84%89%E1%85%B3_jpg/%E1%84%89%E1%85%B3%E1%84%8B%E1%85%AE-min.jpg", difficulty: ["이지", "노말", "하드"],
                 price: ["10000", "20000", "30000"]),
        BossList(
            name: "데미안",
            thumnailImageURL: "https://github.com/yusw10/iOS-MSG-Data/blob/main/%E1%84%87%E1%85%A9%E1%84%89%E1%85%B3_jpg/%E1%84%83%E1%85%A6%E1%84%86%E1%85%B5%E1%84%8B%E1%85%A1%E1%86%AB-min.jpg?raw=true", difficulty: ["이지", "노말"],
            price: ["10000", "20000", "30000"]
        ),
        BossList(name: "루시드",
                 thumnailImageURL: "https://github.com/yusw10/iOS-MSG-Data/blob/main/%E1%84%87%E1%85%A9%E1%84%89%E1%85%B3_jpg/%E1%84%85%E1%85%AE%E1%84%89%E1%85%B5%E1%84%83%E1%85%B3-min.jpg?raw=true", difficulty: ["이지", "노말", "하드"],
                 price: ["10000", "20000", "30000"]),
        BossList(name: "윌",
                 thumnailImageURL: "https://github.com/yusw10/iOS-MSG-Data/blob/main/%E1%84%87%E1%85%A9%E1%84%89%E1%85%B3_jpg/%E1%84%8B%E1%85%B1%E1%86%AF-min.jpg?raw=true", difficulty: ["이지", "노말", "하드"],
                 price: ["10000", "20000", "30000"])
    ]
    
    enum Section {
        case main
    }
    
    private let worldPickerView = UIPickerView(
        frame: CGRect(x: 5, y: 50, width: 260, height: 160)
    )
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.setupCollectionViewLayout()
    ).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .secondarySystemBackground
        $0.register(
            WeeklyBossAddViewCell.self,
            forCellWithReuseIdentifier: WeeklyBossAddViewCell.id
        )
    }
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, BossList> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewListCell? in
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WeeklyBossAddViewCell.id,
            for: indexPath
        ) as! WeeklyBossAddViewCell
        
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 15
        
        cell.viewController = self

        cell.configure(
            bossList: self.bossList[indexPath.row],
            characterInfo: self.characterInfo ?? CharacterInfo()
        )
      
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
        
        setupView()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applySnapShot()
    }
    
}

private extension WeeklyBossAddViewController {
    
    func setupView() {
        [collectionView].forEach { view in
            self.view.addSubview(view)
        }
    }
    
    func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.view)
        }
    }
    
    func setupCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .fractionalHeight(1))
        )
        item.contentInsets.top = 16
        item.contentInsets.trailing = 16

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1/2)
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
    
    func applySnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, BossList>()
        snapshot.appendSections([.main])
        snapshot.appendItems(bossList)
        
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}
