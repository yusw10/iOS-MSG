//
//  WeeklyBossCalculatorViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/14.
//

import UIKit
import SnapKit
import Then

final class WeeklyBossCalculatorViewController: ContentViewController {
    
    enum Section: CaseIterable {
        case main
    }

    private var characterInfo = [CharacterInfo]()
    
    private let worldList = [
        "스카니아", "베라", "루나", "제니스", "크로아", "유니온", "엘리시움", "이노시스", "레드", "오로라", "아케인", "노바", "리부트", "리부트2"
    ]
    
    private var selectWorld = ""

    private let worldPickerView = UIPickerView(
        frame: CGRect(x: 5, y: 50, width: 260, height: 160)
    )
    
    private var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private lazy var characterAddButton = UIButton().then {
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
        $0.backgroundColor = .systemBrown
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, CharacterInfo> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewListCell? in
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharacterViewCell.id,
            for: indexPath
        ) as! CharacterViewCell
        
        var bossClearCount = 0
        CoreDatamanager.shared.readBossList(characterInfo: self.characterInfo[indexPath.row]).forEach({ element in
            if element.checkClear {
                bossClearCount += 1
            }
        })
        
        cell.configure(
            name: self.characterInfo[indexPath.row].name ?? "",
            world: self.characterInfo[indexPath.row].world ?? "",
            totalCount: ("\(bossClearCount) / \(self.characterInfo[indexPath.row].bossInformations?.count ?? 0)")
        )
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupView()
        setupLayout()
        setupButton()
        setupPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applySnapShot()
    }
    
}

private extension WeeklyBossCalculatorViewController {
    
    func setupCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        var layoutConfig = UICollectionLayoutListConfiguration(
            appearance: .plain
        )
        layoutConfig.trailingSwipeActionsConfigurationProvider = setupSwipeActions
        
        
        let listLayout = UICollectionViewCompositionalLayout.list(
            using: layoutConfig
        )
        
        collectionView.collectionViewLayout = listLayout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        
        collectionView.register(
            CharacterViewCell.self,
            forCellWithReuseIdentifier: CharacterViewCell.id
        )
    }
    
    func setupView() {
        [collectionView, characterAddButton].forEach { view in
            self.view.addSubview(view)
        }
    }
    
    func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.view)
        }
        
        characterAddButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self.view).inset(20)
            
            make.width.height.equalTo(self.view.snp.width).multipliedBy(0.15)
        }
    }
    
    func setupButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        
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
              let id = diffableDataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: deleteActionTitle
        ) { [weak self] _, _, completion in
            CoreDatamanager.shared.deleteCharacter(id)
            self?.applySnapShot()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func applySnapShot() {
        characterInfo = CoreDatamanager.shared.readCharter()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, CharacterInfo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(characterInfo)
        
        diffableDataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

@objc private extension WeeklyBossCalculatorViewController {
    
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
                CoreDatamanager.shared.createCharacter(
                                    name: alert.textFields?[0].text ?? "",
                                    world: self?.selectWorld ?? ""
                                )
                self?.applySnapShot()
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

extension WeeklyBossCalculatorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weeklyBossListViewController = WeeklyBossListViewController(
            characterInfo: characterInfo[indexPath.row]
        )
        
        navigationController?.pushViewController(weeklyBossListViewController, animated: true)
    }
    
}

extension WeeklyBossCalculatorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
