//
//  JobDetailCollectionViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/01/31.
//

import UIKit
import SnapKit
import Then

final class JobDetailCollectionViewController: UICollectionViewController {
    weak var delegate: JobDetailControllerDelegate?
    
    // MARK: - Properties
    enum Section: CaseIterable {
        case jobImage
        case linkSkill
        case reinforceSkillCore
        case matrixSkillCore
    }
    
    private let viewModel: JobInfoViewModel

    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, AnyHashable> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewListCell? in
        
        if let object = object as? Job {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobImageViewCell.id, for: indexPath) as! JobImageViewCell
            cell.configure(imageURL: object.imageURL)
            return cell
        } else if let object = object as? Skill {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillListViewCell.id, for: indexPath) as! SkillListViewCell
            cell.configure(title: object.name, imageURL: object.imageURL)
            cell.accessories = [.disclosureIndicator()]
            return cell
        } else if let object = object as? ReinforceSkillCore {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillListViewCell.id, for: indexPath) as! SkillListViewCell
            cell.configure(title: object.name, imageURL: object.imageURL)
            cell.accessories = [.disclosureIndicator()]
            return cell
        }
        
        return nil
    }
    
    // MARK: - initializer
    init(
        viewModel: JobInfoViewModel
    ) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - App LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setLayouts()
        setCollectionView()
        setdiffableDataSource()
        
        self.viewModel.jobInfo.subscribe(on: self) { [self] info in
            guard let info = info else { return }

            var snapshot = self.diffableDataSource.snapshot()
            snapshot.appendSections([.jobImage, .linkSkill, .matrixSkillCore, .reinforceSkillCore])
            snapshot.appendItems([info], toSection: .jobImage)
            snapshot.appendItems([info.linkSkill], toSection: .linkSkill)
            snapshot.appendItems(info.matrixSkillCore, toSection: .matrixSkillCore)
            snapshot.appendItems(info.reinforceSkillCore, toSection: .reinforceSkillCore)

            diffableDataSource.apply(snapshot, animatingDifferences: false)
        }
        
        delegate?.selectJobDetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            var snapshot = self.diffableDataSource.snapshot()
            snapshot.deleteAllItems()
            diffableDataSource.apply(snapshot, animatingDifferences: false)
            viewModel.jobInfo.unsunscribe(observer: self)
        }
    }
    
    // MARK: - Methods

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = diffableDataSource.itemIdentifier(for: indexPath)
        let skillDetailViewController = SkillDetailViewController()
        
        if object is Skill {
            navigationController?.pushViewController(skillDetailViewController, animated: true)
            
        }  else if object is Skill {
            navigationController?.pushViewController(skillDetailViewController, animated: true)

        } else if object is ReinforceSkillCore {
            navigationController?.pushViewController(skillDetailViewController, animated: true)

        }
    }
    
}

// MARK: - Private Methods

extension JobDetailCollectionViewController {
    
    private func addSubViews() {
        self.view.addSubview(collectionView)
    }
    
    private func setLayouts() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.headerMode = .supplementary
        
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        collectionView.collectionViewLayout = listLayout
        
        collectionView.register(
            TitleHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeaderView.id
        )
        collectionView.register(
            JobImageViewCell.self,
            forCellWithReuseIdentifier: JobImageViewCell.id
        )
        collectionView.register(
            SkillListViewCell.self,
            forCellWithReuseIdentifier: SkillListViewCell.id
        )
       
    }
    
    private func setdiffableDataSource() {
        diffableDataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind,
                withReuseIdentifier: TitleHeaderView.id,
                for: indexPath
            ) as! TitleHeaderView
            
            let snapshot = self.diffableDataSource.snapshot()
            let object = self.diffableDataSource.itemIdentifier(for: indexPath)
            let section = snapshot.sectionIdentifier(containingItem: object!)!
            
            if section == .linkSkill {
                header.configure(titleText: "링크 스킬")
            } else if section == .matrixSkillCore {
                header.configure(titleText: "5차 스킬 코어")
            } else if section == .reinforceSkillCore {
                header.configure(titleText: "추천 직업 스킬 코어 강화")
            }
            
            return header
        }
    }
    
}

protocol JobDetailControllerDelegate: AnyObject {
    func selectJobDetail()
}
