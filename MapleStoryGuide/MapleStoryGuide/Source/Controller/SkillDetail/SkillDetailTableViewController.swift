//
//  SkillDetailTableViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/02/02.
//

import UIKit
import SnapKit

final class SkillDetailTableViewController: ContentTableViewController {
    
    // MARK: - Properties
    enum Section: CaseIterable {
        case reinforceSkillCore
    }
    
    private lazy var diffableDataSource: UITableViewDiffableDataSource<Section, AnyHashable> = .init(tableView: tableView) { (tableView, indexPath, object) -> UITableViewCell? in
        
        if let object = object as? Skill {
            let cell = tableView.dequeueReusableCell(withIdentifier: SkillDetailViewCell.id, for: indexPath) as! SkillDetailViewCell
            cell.configure(
                imageURL: object.imageURL,
                title: object.name,
                description: object.description
            )
            return cell
        } else if let object = object as? ReinforceSkillCore {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReinforceSkillDetailViewCell.id, for: indexPath) as! ReinforceSkillDetailViewCell
            cell.configure(
                imageURL: object.imageURL,
                title: object.name,
                description20: object.description20,
                description40: object.description40
            )
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.isMovingFromParent {
            var snapshot = self.diffableDataSource.snapshot()
            snapshot.deleteAllItems()
            diffableDataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    // MARK: - Methods
    
    func configure(data: [AnyHashable], title: String) {
        navigationItem.title = title
        var snapshot = self.diffableDataSource.snapshot()
        
        snapshot.appendSections([.reinforceSkillCore])
        for datum in data {
            snapshot.appendItems([datum], toSection: .reinforceSkillCore)
        }

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
            frame: view.bounds
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.register(ReinforceSkillDetailViewCell.self, forCellReuseIdentifier: ReinforceSkillDetailViewCell.id)
        tableView.register(SkillDetailViewCell.self, forCellReuseIdentifier: SkillDetailViewCell.id)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
