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
    
    var characterInfo: MyCharacter?

    private var bossDifficultyList = [ModeLevel]()
    private var bossPriceList = [RewardPrice]()
    private var choiceBossDifficulty = ""
    private var choiceBossPrice = ""
    
    private let repository = LocalWeeklyBossInfoRepository()
    private var viewModel: WeelyBossAddViewModel! = nil
    
    private let worldPickerView = UIPickerView(
        frame: CGRect(x: 5, y: 20, width: 260, height: 160)
    )
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.setupCollectionViewLayout()
    ).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.backgroundColor = .secondarySystemBackground
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
    
    init(characterInfo: MyCharacter) {
        super.init(nibName: nil, bundle: nil)

        self.characterInfo = characterInfo
        viewModel = WeelyBossAddViewModel(
            repository: self.repository,
            characterInfo: characterInfo
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        
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
        
        viewModel.bossList.unsunscribe(observer: self)
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
    
    func setupPickerView() {
        worldPickerView.delegate = self
        worldPickerView.dataSource = self
        worldPickerView.selectRow(
            0,
            inComponent: 0,
            animated: true
        )
    }
    
    func applySnapShot(data: [WeeklyBossInfo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WeeklyBossInfo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension WeeklyBossAddViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bossDifficultyList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bossDifficultyList[row].mode
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choiceBossDifficulty = bossDifficultyList[row].mode
        choiceBossPrice = bossPriceList[row].price.description
    }
    
}

extension WeeklyBossAddViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        bossDifficultyList = viewModel.bossList.value[indexPath.row].level
        bossPriceList = viewModel.bossList.value[indexPath.row].rewardPrice
        choiceBossDifficulty = bossDifficultyList[0].mode
        choiceBossPrice = bossPriceList[0].price.description
        
        setupPickerView()

        let bossMemberList = ["1", "2", "3", "4", "5", "6"]
        let alert = UIAlertController(
            title: "난이도를 선택해 주세요.",
            message: "\n\n\n\n\n\n",
            preferredStyle: .alert
        )
        alert.view.addSubview(worldPickerView)
        
        alert.addTextField { textField in
            textField.placeholder = "파티원 수를 입력해주세요.(1인 ~ 6인)"
        }
        
        let ok = UIAlertAction(
            title: "OK",
            style: .default
        ) { (ok) in
            if !bossMemberList.contains(alert.textFields?[0].text ?? "") {
                let alert = UIAlertController(
                    title: "파티원 수는 필수 입력 입니다.",
                    message: "1 부터 6 까지의 숫자만 입력해주세요.",
                    preferredStyle: .alert
                )
                let ok = UIAlertAction(
                    title: "ok",
                    style: .cancel
                ) { (cancel) in
                    
                }
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
            } else {
                self.delegate?.weelyBossAdd(
                    from:
                        MyWeeklyBoss(
                            checkClear: false,
                            crystalStonePrice: self.choiceBossPrice,
                            difficulty: self.choiceBossDifficulty,
                            name: self.viewModel.bossList.value[indexPath.row].name,
                            thumnailImageURL: self.viewModel.bossList.value[indexPath.row].imageURL,
                            member: alert.textFields?[0].text ?? ""
                        )
                )
                let alert = UIAlertController(
                    title: "\(self.viewModel.bossList.value[indexPath.row].name) 보스 정보가 저장되었습니다.",
                    message: "",
                    preferredStyle: .alert
                )
                let ok = UIAlertAction(
                    title: "ok",
                    style: .cancel
                ) { (cancel) in
                    
                }
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        let cancel = UIAlertAction(
            title: "cancel",
            style: .cancel
        ) { (cancel) in
            
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension String {
    
    var insertComma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        return numberFormatter.string(for: Double(self)) ?? self
    }
        
    var rebootPrice: String {
        let price = (Int(self) ?? 0) * 5
        
        return price.description
    }
    
}
