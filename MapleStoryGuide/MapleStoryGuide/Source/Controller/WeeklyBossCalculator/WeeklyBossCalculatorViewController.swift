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
    
    private let pickerList = [
        "스카니아", "베라", "루나", "제니스", "크로아", "유니온", "엘리시움", "이노시스", "레드", "오로라", "아케인", "노바", "리부트", "리부트2"
    ]
    
    private var typeValue = ""
    private var characterInfo = [CharacterInfo]()

    private let worldPickerView = UIPickerView(
        frame: CGRect(x: 5, y: 50, width: 260, height: 160)
    )
    
    private var collectionView: UICollectionView!
    
    private lazy var addButton = UIButton().then {
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
        
        var myCount = 0
        CoreDatamanager.shared.readBossList(characterInfo: self.characterInfo[indexPath.row]).forEach({ element in
            if element.checkClear {
                myCount += 1
            }
        })
        
        cell.configure(
            name: self.characterInfo[indexPath.row].name ?? "",
            world: self.characterInfo[indexPath.row].world ?? "",
            totalCount: ("\(myCount) / \(self.characterInfo[indexPath.row].bossInfos?.count ?? 0)")
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
        updateSnapShot()
    }
    
}

extension WeeklyBossCalculatorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weeklyBossListViewController = WeeklyBossListViewController(characterInfo: characterInfo[indexPath.row])
        
        navigationController?.pushViewController(weeklyBossListViewController, animated: true)
    }
    
}

extension WeeklyBossCalculatorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if row == 0 {
            typeValue = "스카니아"
        } else if row == 1 {
            typeValue = "베라"
        } else if row == 2 {
            typeValue = "루나"
        } else if row == 3 {
            typeValue = "제니스"
        } else if row == 4 {
            typeValue = "크로아"
        } else if row == 5 {
            typeValue = "유니온"
        } else if row == 6 {
            typeValue = "엘리시움"
        } else if row == 7 {
            typeValue = "이노시스"
        } else if row == 8 {
            typeValue = "레드"
        } else if row == 9 {
            typeValue = "오로라"
        } else if row == 10 {
            typeValue = "아케인"
        } else if row == 11 {
            typeValue = "노바"
        } else if row == 12 {
            typeValue = "리부트"
        } else if row == 13 {
            typeValue = "리부트2"
        }
    }
    
}

private extension WeeklyBossCalculatorViewController {
    
    func setupCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        var layoutConfig = UICollectionLayoutListConfiguration(
            appearance: .insetGrouped
        )
        layoutConfig.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        
        
        let listLayout = UICollectionViewCompositionalLayout.list(
            using: layoutConfig
        )
        
        collectionView.collectionViewLayout = listLayout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.delegate = self
        
        collectionView.register(
            CharacterViewCell.self,
            forCellWithReuseIdentifier: CharacterViewCell.id
        )
    }
    
    func setupView() {
        [collectionView, addButton].forEach { view in
            self.view.addSubview(view)
        }
    }
    
    func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.view)
        }
        
        addButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self.view).inset(20)
            
            make.width.height.equalTo(self.view.snp.width).multipliedBy(0.2)
        }
    }
    
    func setupButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        
        addButton.tintColor = .white
        addButton.setImage(image, for: .normal)
        
        addButton.addTarget(self, action: #selector(TappedAddButton), for: .touchUpInside)
    }
    
    func setupPickerView() {
        typeValue = pickerList[pickerList.count/2]
        
        worldPickerView.delegate = self
        worldPickerView.dataSource = self
        worldPickerView.selectRow(
            pickerList.count/2,
            inComponent: 0,
            animated: true
        )
    }
    
    func updateSnapShot() {
        characterInfo = CoreDatamanager.shared.readCharter()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, CharacterInfo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(characterInfo)
        
        diffableDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc func TappedAddButton() {
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
        ) { (ok) in
            
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

                self.present(alert, animated: true, completion: nil)
            } else {
                CoreDatamanager.shared.createCharacter(
                                    name: alert.textFields?[0].text ?? "",
                                    world: self.typeValue
                                )
                self.updateSnapShot()
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
    
    func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
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
            self?.updateSnapShot()
            
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
