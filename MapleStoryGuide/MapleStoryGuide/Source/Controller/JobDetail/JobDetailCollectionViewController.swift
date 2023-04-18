//
//  JobDetailCollectionViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/01/31.
//

import UIKit
import SnapKit
import Then

final class JobDetailCollectionViewController: ContentCollectionViewController {
    enum Section: CaseIterable {
        case jobImage
        case unionEffect
        case linkSkill
        case reinforceSkillCore
        case matrixSkillCore
    }
    
    // MARK: - Properties
    weak var jobDelegate: JobDetailControllerDelegate?
    private let viewModel: JobInfoViewModel
    private var linkSkillData: [AnyHashable] = []
    private var skillCoreData: [AnyHashable] = []
    private var reinforceSkillCoreData: [AnyHashable] = []

    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, AnyHashable> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewListCell? in
        
        if let object = object as? Job {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobImageViewCell.id, for: indexPath) as! JobImageViewCell
            cell.configure(imageURL: object.imageURL)
            self.navigationController?.navigationBar.topItem?.title = object.name

            return cell
        } else if let object = object as? UnionEffect {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillListViewCell.id, for: indexPath) as! SkillListViewCell
            cell.configure(title: object.name, imageURL: "")
            
            return cell
        } else if let object = object as? Skill {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillListViewCell.id, for: indexPath) as! SkillListViewCell
            cell.configure(title: object.name, imageURL: object.imageURL)
            
            return cell
        } else if let object = object as? ReinforceSkillCore {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillListViewCell.id, for: indexPath) as! SkillListViewCell
            cell.configure(title: object.name, imageURL: object.imageURL)
            
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
        setHeaderView()
        
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
        
        jobDelegate?.selectJobDetail()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.isMovingFromParent {
            var snapshot = self.diffableDataSource.snapshot()
            snapshot.deleteAllItems()
            diffableDataSource.apply(snapshot, animatingDifferences: false)
            viewModel.jobInfo.unsubscribe(observer: self)
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
    
    private func setHeaderView() {
        diffableDataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind,
                withReuseIdentifier: TitleHeaderView.id,
                for: indexPath
            ) as! TitleHeaderView

            let snapshot = self.diffableDataSource.snapshot()
            let object = self.diffableDataSource.itemIdentifier(for: indexPath)
            let section = snapshot.sectionIdentifier(containingItem: object!)!
            
            if section == .jobImage {
                header.screenTransitionButton.isHidden = true
                header.titleLabel.isHidden = true

            } else if section == .unionEffect {
                header.configure(titleText: "유니온 효과")
                header.screenTransitionButton.isHidden = true
                
            } else if section == .linkSkill {
                header.configure(titleText: "링크 스킬")
                header.screenTransitionButton.addTarget(self, action: #selector(self.linkSkillSectionTapAction), for: .touchUpInside)

                for index in 0...(snapshot.numberOfItems(inSection: section) - 1) {
                    let sectionData = self.diffableDataSource.itemIdentifier(for: IndexPath(item: index, section: indexPath.section)) as? Skill
                    self.linkSkillData.append(sectionData)
                }
            } else if section == .matrixSkillCore {
                header.configure(titleText: "5차 스킬 코어")
                header.screenTransitionButton.addTarget(self, action: #selector(self.skillCoreSectionTapAction), for: .touchUpInside)
                
                for index in 0...(snapshot.numberOfItems(inSection: section) - 1) {
                    let sectionData = self.diffableDataSource.itemIdentifier(for: IndexPath(item: index, section: indexPath.section)) as? Skill
                    self.skillCoreData.append(sectionData)
                }
            } else if section == .reinforceSkillCore {
                header.configure(titleText: "추천 직업 스킬 코어 강화")
                header.screenTransitionButton.addTarget(self, action: #selector(self.reinforceSkillCoreSectionTapAction), for: .touchUpInside)

                for index in 0...(snapshot.numberOfItems(inSection: section) - 1) {
                    let sectionData = self.diffableDataSource.itemIdentifier(for: IndexPath(item: index, section: indexPath.section)) as? ReinforceSkillCore
                    self.reinforceSkillCoreData.append(sectionData)
                }
            }
            
            return header
        }
    }
    
    @objc private func linkSkillSectionTapAction() {
        let skillDetailTableViewController = SkillDetailTableViewController()
        skillDetailTableViewController.configure(data: linkSkillData, title: "링크 스킬")
        containerViewController?.pushTableViewController(skillDetailTableViewController)
    }
    
    @objc private func skillCoreSectionTapAction() {
        let skillDetailTableViewController = SkillDetailTableViewController()
        skillDetailTableViewController.configure(data: skillCoreData, title: "5차 스킬 코어")
        containerViewController?.pushTableViewController(skillDetailTableViewController)
    }
    
    @objc private func reinforceSkillCoreSectionTapAction() {
        let skillDetailTableViewController = SkillDetailTableViewController()
        skillDetailTableViewController.configure(data: reinforceSkillCoreData, title: "추천 직업 스킬 코어 강화")
        containerViewController?.pushTableViewController(skillDetailTableViewController)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

protocol JobDetailControllerDelegate: AnyObject {
    func selectJobDetail()
}
