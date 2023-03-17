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
    
    private var collectionView: UICollectionView!
    
    private lazy var addButton = UIButton().then {
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
        $0.backgroundColor = .systemBrown
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, CharacterInfo> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewListCell? in
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterViewCell.id, for: indexPath) as! CharacterViewCell
        
        cell.configure(with: self.characterInfo[indexPath.row])
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupView()
        setupLayout()
        setupButton()
        
        updateSnapShot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
}

extension WeeklyBossCalculatorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weeklyBossListViewController = WeeklyBossListViewController()
        
        weeklyBossListViewController.configure(with: characterInfo[indexPath.row])
        navigationController?.pushViewController(weeklyBossListViewController, animated: true)
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
    
    func updateSnapShot() {
        myCharacter = CoreDatamanager.shared.read()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MyCharacter>()
        snapshot.appendSections([.main])
        
        snapshot.appendItems(myCharacter, toSection: .main)
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func TappedAddButton() {
        let alert = UIAlertController(
            title: "캐릭터 등록",
            message: "닉네임과 월드를 기입해주세요.",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "닉네임"
        }
        alert.addTextField { textField in
            textField.placeholder = "월드"
        }
        
        let ok = UIAlertAction(
            title: "OK",
            style: .default
        ) { (ok) in
            CoreDatamanager.shared.create(
                person: MyCharacter(
                    name: alert.textFields?[0].text ?? "",
                    world: alert.textFields?[1].text ?? "",
                    totalRevenue: "0"
                )
            )
            self.updateSnapShot()
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
        guard let indexPath = indexPath, let id = diffableDataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self] _, _, completion in
            self?.coreDataManager.deleteContact(id)
            self?.updateSnapShot()
            
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
