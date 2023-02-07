//
//  JobListViewController.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/02/05.
//

import UIKit
import Then
import SnapKit

final class JobListViewController: UIViewController {
    
    //MARK: - ViewController Properties
    
    let jobList = JobList

    private lazy var jobListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(JobListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JobListHeaderViewReuse")
        
        $0.register(JobListCollectionViewCell.self, forCellWithReuseIdentifier: "JobListCollectionViewCell")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .green
    }
    
    //MARK: - View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupJobListCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - ViewController Private method
    
    private func setupJobListCollectionView() {
        jobListCollectionView.delegate = self
        jobListCollectionView.dataSource = self
        
        view.addSubview(jobListCollectionView)
        
        jobListCollectionView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.trailing.bottom.equalToSuperview()
        }
    }
}

extension JobListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobListCollectionViewCell", for: indexPath) as? JobListCollectionViewCell else {
            print("??")
            return UICollectionViewCell()
        }
        print(jobList.type[indexPath.section].jobs[indexPath.row].jobImage)
        cell.setupCellImage(title: jobList.type[indexPath.section].jobs[indexPath.row].jobImage)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 80 , height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width - 80 , height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {

        case UICollectionView.elementKindSectionHeader :
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: "JobListHeaderViewReuse",
                for: indexPath
            ) as? JobListHeaderView else {
                return UICollectionReusableView()
            }

            headerView.setupTitle(title: jobList.type[indexPath.section].jobGroupTitle)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(jobList.type.count)
        return jobList.type.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(jobList.type[section].jobs.count)
        return jobList.type[section].jobs.count
    }
}

struct MockData {
    let type: [JobGroup]
}

struct JobGroup {
    let jobGroupTitle: String
    let jobs: [Job]
}

struct Job {
    let title: String
    let jobImage: String
}

let JobList = MockData(type: [
    JobGroup(
        jobGroupTitle: "모험가",
        jobs: [
            Job(title: "히어로", jobImage: "jobList"),
            Job(title: "다크나이트", jobImage: "additionalOption"),
            Job(title: "팔라딘", jobImage: "bossInfo")
        ]
    ),
    JobGroup(
        jobGroupTitle: "시그너스",
        jobs: [
            Job(title: "윈드브레이커", jobImage: "jobList"),
            Job(title: "소울마스터", jobImage: "additionalOption"),
            Job(title: "플레임위자드", jobImage: "bossInfo")
        ]
    ),
    JobGroup(
        jobGroupTitle: "레프",
        jobs: [
            Job(title: "칼리", jobImage: "jobList"),
            Job(title: "일리움", jobImage: "additionalOption"),
            Job(title: "아크", jobImage: "bossInfo")
        ]
    ),
    JobGroup(
        jobGroupTitle: "아니마",
        jobs: [
            Job(title: "호영", jobImage: "jobList"),
            Job(title: "라라", jobImage: "additionalOption")
        ]
    )
])

