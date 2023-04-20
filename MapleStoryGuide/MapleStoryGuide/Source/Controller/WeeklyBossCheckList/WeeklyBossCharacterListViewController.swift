//
//  WeeklyBossCalculatorViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/14.
//

import UIKit
import SnapKit
import Then

final class WeeklyBossCharacterListViewController: ContentMyCharacterListViewController {
    
    enum Section: CaseIterable {
        case main
    }

    private let viewModel = WeeklyBossCharacterListViewModel()
        
    private let worldList = [
        "스카니아", "베라", "루나", "제니스", "크로아", "유니온", "엘리시움", "이노시스", "레드", "오로라", "아케인", "노바", "리부트", "리부트2"
    ]
    
    private var selectWorld = ""

    private let worldPickerView = UIPickerView(
        frame: CGRect(x: 5, y: 50, width: 260, height: 160)
    )
    
    private let kindView = KindHeaderView()
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.setupCollectionViewLayout()
    ).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.register(
            WeeklyBossCharacterListCell.self,
            forCellWithReuseIdentifier: WeeklyBossCharacterListCell.id
        )
    }
    
    private lazy var characterAddButton = UIButton().then {
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
        $0.backgroundColor = .systemBrown
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, MyCharacter> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewListCell? in
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WeeklyBossCharacterListCell.id,
            for: indexPath
        ) as! WeeklyBossCharacterListCell
        
        var bossClearCount = 0
        
        object.bossInformations.forEach { boss in
            if boss.checkClear {
                bossClearCount += 1
            }
        }
        cell.configure(
            name: object.name,
            world: object.world,
            totalCount: ("\(bossClearCount) / \(object.bossInformations.count)")
        )
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        navigationItem.title = "주간 보스 체크 리스트"
        setupView()
        setupLayout()
        setupButton()
        setupPickerView()
        configureMenu()
        
        viewModel.characterInfo.subscribe(on: self) { [weak self] charterInfo in
            self?.applySnapShot(from: charterInfo)
        }
        
        viewModel.fetchCharacterInfo()
    }
    

}

private extension WeeklyBossCharacterListViewController {
    
    func setupView() {
        [kindView, collectionView, characterAddButton].forEach { view in
            self.view.addSubview(view)
        }
    }
    
    func setupLayout() {
        kindView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.05)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.kindView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        characterAddButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self.view).inset(20)
            
            make.width.height.equalTo(self.view.snp.width).multipliedBy(0.15)
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
    
    func setupButton() {
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 30,
            weight: .light
        )
        let image = UIImage(
            systemName: "plus",
            withConfiguration: imageConfig
        )
        
        characterAddButton.tintColor = .white
        characterAddButton.setImage(image, for: .normal)
        characterAddButton.addTarget(self, action: #selector(TappedAddButton), for: .touchUpInside)
    }
    
    func setupPickerView() {
        selectWorld = worldList[worldList.count/2]
        
        worldPickerView.delegate = self
        worldPickerView.dataSource = self
        worldPickerView.selectRow(
            worldList.count/2,
            inComponent: 0,
            animated: true
        )
    }
    
    func setupSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath,
              let _ = diffableDataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: deleteActionTitle
        ) { [weak self] _, _, completion in
            self?.viewModel.deleteCharacter(index: indexPath.row)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func applySnapShot(from data: [MyCharacter]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MyCharacter>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureMenu() {
        self.resetButtonItem.menu =  UIMenu(title: "",
                                            image: nil,
                                            identifier: nil,
                                            options: .displayInline,
                                            children: self.configureMenuAction()
        )
    }
    
    private func configureMenuAction() -> [UIAction] {
        let weeklyResetAction = UIAction(title: "주간 보스 초기화") { action in
            self.viewModel.resetWeeklyBossData()
        }
        
        let monthlyResetAction = UIAction(title: "월간 보스 초기화") { action in
            self.viewModel.resetMonthlyBossData()
        }
        
        let cancelAction = UIAction(title: "취소", attributes: .destructive) { _ in }
        
        return [weeklyResetAction, monthlyResetAction, cancelAction]
    }
}

@objc private extension WeeklyBossCharacterListViewController {
    
    func TappedAddButton() {
        let alert = UIAlertController(
            title: "캐릭터 등록",
            message: "\n\n\n\n\n\n\n\n\n",
            preferredStyle: .alert
        )
        alert.view.addSubview(worldPickerView)

        alert.addTextField { textField in
            textField.placeholder = "닉네임"
        }
        
        let ok = UIAlertAction(
            title: "OK",
            style: .default
        ) { [weak self] ok in
            if alert.textFields?[0].text == "" {
                let alert = UIAlertController(
                    title: "캐릭터 닉네임은 필수 입력 입니다.",
                    message: "최소 한글자 이상 입력해주세요.",
                    preferredStyle: .alert
                )
                let ok = UIAlertAction(
                    title: "ok",
                    style: .cancel
                ) { (cancel) in
                    
                }
                alert.addAction(ok)
                
                self?.present(alert, animated: true, completion: nil)
            } else {
                self?.viewModel.createCharacter(
                    name: alert.textFields?[0].text ?? "",
                    world: self?.selectWorld ?? ""
                )
            }
        }
        let cancel = UIAlertAction(
            title: "cancel",
            style: .cancel
        ) 
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension WeeklyBossCharacterListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weeklyBossListViewController = WeeklyBossCalculatorViewController(
            viewModel: viewModel,
            selectedIndex: indexPath.row
        )
        
        navigationController?.pushViewController(weeklyBossListViewController, animated: true)
        self.collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension WeeklyBossCharacterListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return worldList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return worldList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectWorld = worldList[row]
    }
    
}

final class KindHeaderView: UIView {
    
    static let id = "WeeklyBossCharacterListCell"
    
    private lazy var horizontalStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var worldLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .MapleTitleFont()
        $0.text = "월드"
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .MapleTitleFont()
        $0.text = "캐릭터"
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var totalPriceLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .MapleTitleFont()
        $0.text = "클리어"
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension KindHeaderView {
    
    func setupView() {
        self.addSubview(horizontalStackView)
        
        [worldLabel, nameLabel, totalPriceLabel].forEach { view in
            horizontalStackView.addArrangedSubview(view)
        }
    }
    
    func setupLayout() {
        horizontalStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self).inset(10)
            make.width.equalTo(self)
        }
    }
    
}
