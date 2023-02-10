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
    
    // MARK: - Properties

//    private let mockDataItems = [
//        JobInfo(
//            name: "은월",
//            type: "해적",
//            welcomeClass: "전사",
//            imageQuery: "은월",
//            unionEffect: "힘",
//            keyword: [
//                Keyword(name: "힘 증가")
//            ],
//            linkSkill: [
//                LinkSkill(
//                    name: "스피릿 오브 프리덤",
//                    description: "자유를 염원하는 레지스탕스가 가진 혼의 힘이다.\n월드 내 서로 다른 레지스탕스 직업군이 존재할 경우 한 캐릭터에 최대 4번 중복해서 링크 스킬 지급이 가능하다.",
//                    imageQuery: "스피릿 오브 프리덤"
//                )
//            ],
//            reinforceSkillCore: [
//                ReinforceSkillCore(
//                    name: "폭류권",
//                    description20: "최대 공격 가능 대상 1 증가",
//                    description40: "몬스터 방어율 무시 20% 증가",
//                    imageQuery: "폭류권"
//                ),
//                ReinforceSkillCore(
//                    name: "여우령",
//                    description20: "최대 공격 가능 대상 1 증가",
//                    description40: "몬스터 방어율 무시 20% 증가",
//                    imageQuery: "여우령"
//                ),
//                ReinforceSkillCore(
//                    name: "소혼 장막",
//                    description20: "최대 공격 가능 대상 1 증가",
//                    description40: "몬스터 방어율 무시 20% 증가",
//                    imageQuery: "소혼 장막"
//                ),
//                ReinforceSkillCore(
//                    name: "귀참",
//                    description20: "최대 공격 가능 대상 1 증가",
//                    description40: "몬스터 방어율 무시 20% 증가",
//                    imageQuery: "귀참"
//                ),
//                ReinforceSkillCore(
//                    name: "정령의 화신",
//                    description20: "최대 공격 가능 대상 1 증가",
//                    description40: "몬스터 방어율 무시 20% 증가",
//                    imageQuery: "정령의 화신"
//                )
//            ],
//            matrixSkillCore: [
//                MatrixSkillCore(
//                    name: "정령 집속",
//                    description: "모든 정령을 몸 속으로 받아들여 하나가 된다. 자동 발동된 공격은 공격 반사 상태의 적을 공격해도 피해를 입지 않는다.",
//                    imageQuery: "정령 집속"
//                ),
//                MatrixSkillCore(
//                    name: "귀문진",
//                    description: "정령이 소환되는 영역을 생성한다. 정령은 공격 반사의 적을 공격해도 피해를 입지 않는다.",
//                    imageQuery: "귀문진"
//                ),
//                MatrixSkillCore(
//                    name: "진 귀참",
//                    description: "정령과의 결속을 중첩시켜 더욱 강력한 귀참으로 공격한다. 사용 후 재강화되는데는 시간이 필요하다.",
//                    imageQuery: "진 귀참"
//                ),
//                MatrixSkillCore(
//                    name: "파쇄 연권",
//                    description: "강령시킨 땅의 정령에 여우신의 힘을 더해 파괴적인 연타를 날린다.",
//                    imageQuery: "파쇄 연권"
//                )
//            ]
//        )
//    ]

    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, AnyHashable> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewListCell? in
        
        if let object = object as? JobInfo {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobImageViewCell.id, for: indexPath) as! JobImageViewCell
            
            cell.configure(image: UIImage(named: object.imageQuery))
            
            return cell
        } else if let object = object as? LinkSkill {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillListViewCell.id, for: indexPath) as! SkillListViewCell
            
            cell.configure(title: object.name, image: UIImage(named: object.imageQuery))
            cell.accessories = [.disclosureIndicator()]
            
            return cell
        } else if let object = object as? MatrixSkillCore {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillListViewCell.id, for: indexPath) as! SkillListViewCell
            
            cell.configure(title: object.name, image: UIImage(named: object.imageQuery))
            cell.accessories = [.disclosureIndicator()]
            
            return cell
        } else if let object = object as? ReinforceSkillCore {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillListViewCell.id, for: indexPath) as! SkillListViewCell
            
            cell.configure(title: object.name, image: UIImage(named: object.imageQuery))
            cell.accessories = [.disclosureIndicator()]
            
            return cell
        }
        
        return nil
    }
    
    // MARK: - initializer

    init() {
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
    }
    
    // MARK: - Methods

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = diffableDataSource.itemIdentifier(for: indexPath)
        let skillDetailViewController = SkillDetailViewController()
        
        if object is LinkSkill {
            navigationController?.pushViewController(skillDetailViewController, animated: true)
            
            skillDetailViewController.configure(
                image: UIImage(named: mockDataItems[0].linkSkill[indexPath.row].imageQuery)!,
                title: mockDataItems[0].linkSkill[indexPath.row].name,
                description: mockDataItems[0].linkSkill[indexPath.row].description
            )
        }  else if object is MatrixSkillCore {
            navigationController?.pushViewController(skillDetailViewController, animated: true)
            skillDetailViewController.configure(
                image: UIImage(named: mockDataItems[0].matrixSkillCore[indexPath.row].imageQuery)!,
                title: mockDataItems[0].matrixSkillCore[indexPath.row].name,
                description: mockDataItems[0].matrixSkillCore[indexPath.row].description
            )
        } else if object is ReinforceSkillCore {
            navigationController?.pushViewController(skillDetailViewController, animated: true)
            skillDetailViewController.configure(
                image: UIImage(named: mockDataItems[0].reinforceSkillCore[indexPath.row].imageQuery)!,
                title: mockDataItems[0].reinforceSkillCore[indexPath.row].name,
                description: mockDataItems[0].reinforceSkillCore[indexPath.row].description20
            )
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
        
        var snapshot = self.diffableDataSource.snapshot()
        
        snapshot.appendSections([.jobImage, .linkSkill, .matrixSkillCore, .reinforceSkillCore])
        snapshot.appendItems(mockDataItems, toSection: .jobImage)
        
        let linkSkill = mockDataItems[0].linkSkill
        snapshot.appendItems(linkSkill, toSection: .linkSkill)

        let matrixSkill = mockDataItems[0].matrixSkillCore
        snapshot.appendItems(matrixSkill, toSection: .matrixSkillCore)
        
        let reinforceSkill = mockDataItems[0].reinforceSkillCore
        snapshot.appendItems(reinforceSkill, toSection: .reinforceSkillCore)
        
        diffableDataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
