//
//  JobDetailViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/01/31.
//

import UIKit
import SnapKit
import Then

final class JobDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var dataSource = MockData.dataSource
    
    private lazy var jobDetailView = JobDetailView()
    
    // MARK: - App LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .secondarySystemBackground
        addSubViews()
        setLayouts()
        
        jobDetailView.collectionView.dataSource = self
        jobDetailView.collectionView.delegate = self
    }
    
}

// MARK: - Private Methods

extension JobDetailViewController {
    
    // MARK: - Add View, Set Layout
    
    private func addSubViews() {
        self.view.addSubview(jobDetailView)
    }
    
    private func setLayouts() {
        jobDetailView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(10)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-10)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
    
}

// MARK: - CollectionView DataSource Methods

extension JobDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch dataSource[section] {
            
        case let .mainImage(image):
            return image.count
        case let .link(skills):
            return skills.count
        case let .reinforce(skills):
            return skills.count
        case let .matrix(skills):
            return skills.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch dataSource[indexPath.section] {
            
        case let .mainImage(image):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobImageViewCell.id, for: indexPath) as! JobImageViewCell
            let item = image[indexPath.item]
            cell.prepare(image: item.image)
            
            return cell
        case let .link(skills):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillListViewCell.id, for: indexPath) as! SkillListViewCell
            let item = skills[indexPath.item]
            cell.prepare(title: item.title, image: item.image)
            cell.accessories = [.disclosureIndicator()]

            return cell
        case let .reinforce(skills):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillListViewCell.id, for: indexPath) as! SkillListViewCell
            let item = skills[indexPath.item]
            cell.prepare(title: item.title, image: item.image)
            cell.accessories = [.disclosureIndicator()]

            return cell
        case let .matrix(skills):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillListViewCell.id, for: indexPath) as! SkillListViewCell
            let item = skills[indexPath.item]
            cell.prepare(title: item.title, image: item.image)
            cell.accessories = [.disclosureIndicator()]

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: TitleHeaderView.id,
                for: indexPath
            ) as! TitleHeaderView
            if indexPath.section == 1 {
                header.prepare(titleText: "링크 스킬")
            } else if indexPath.section == 2 {
                header.prepare(titleText: "직업 코어 스킬")
            } else if indexPath.section == 3 {
                header.prepare(titleText: "5차 코어 스킬")
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
}

// MARK: - CollectionView Delegate Methods

extension JobDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let skillDetailViewController = SkillDetailViewController()
        
        switch dataSource[indexPath.section] {
            
        case let .mainImage(image):
            print(image[indexPath.row])
            
        case let .link(skills):
            navigationController?.pushViewController(skillDetailViewController, animated: true)
            
            skillDetailViewController.configure(
                image: skills[indexPath.row].image,
                title: skills[indexPath.row].title,
                description: skills[indexPath.row].desc
            )
            
        case let .reinforce(skills):
            navigationController?.pushViewController(skillDetailViewController, animated: true)
            
            skillDetailViewController.configure(
                image: skills[indexPath.row].image,
                title: skills[indexPath.row].title,
                description: skills[indexPath.row].desc
            )
            
        case let .matrix(skills):
            navigationController?.pushViewController(skillDetailViewController, animated: true)
            
            skillDetailViewController.configure(
                image: skills[indexPath.row].image,
                title: skills[indexPath.row].title,
                description: skills[indexPath.row].desc
            )
        }
    }
    
}

