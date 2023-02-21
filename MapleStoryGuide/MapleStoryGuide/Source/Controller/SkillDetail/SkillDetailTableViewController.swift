//
//  SkillDetailTableViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/02/02.
//

import UIKit
import SnapKit

final class SkillDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    enum Section: CaseIterable {
        case reinforceSkillCore
    }
    
    private lazy var diffableDataSource: UITableViewDiffableDataSource<Section, AnyHashable> = .init(tableView: tableView) { (tableView, indexPath, object) -> UITableViewCell? in
        
        if let object = object as? ReinforceSkillCore {
            let cell = tableView.dequeueReusableCell(withIdentifier: SkillDetailViewCell.id, for: indexPath) as! SkillDetailViewCell
            cell.configure(image: UIImage(named: "파쇄 연권")!, title: object.name, description: object.description20)
            return cell
        }
        
        return nil
    }
    
    // MARK: - App LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setLayouts()
        setTableView()
    }
    
    // MARK: - Methods
    
    func configure(data: AnyHashable) {
        var snapshot = self.diffableDataSource.snapshot()
        
        snapshot.appendSections([.reinforceSkillCore])
        snapshot.appendItems([data], toSection: .reinforceSkillCore)

        diffableDataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Private Methods

extension SkillDetailTableViewController {
    
    private func setLayouts() {
        tableView.snp.makeConstraints { make in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.right.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    private func setTableView() {
        tableView = UITableView(
            frame: view.bounds,
            style: .insetGrouped
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
//        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//        layoutConfig.headerMode = .supplementary
//
//        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
//
//        collectionView.collectionViewLayout = listLayout
        
        tableView.register(SkillDetailViewCell.self, forCellReuseIdentifier: SkillDetailViewCell.id)
    }
}
