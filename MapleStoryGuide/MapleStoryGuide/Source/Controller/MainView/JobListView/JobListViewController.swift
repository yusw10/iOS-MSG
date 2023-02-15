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
 
    let repository = AssetJobInfoRepository()
    var viewModel: JobInfoViewModel! = nil
    //MARK: - ViewController Properties
    //TODO: 뷰모델로부터 받는 데이터로 갈아끼우기
    var jobList = [JobGroup]()

    private lazy var jobListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .secondarySystemBackground
        $0.register(JobListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JobListHeaderViewReuse")
        
        $0.register(JobListCollectionViewCell.self, forCellWithReuseIdentifier: "JobListCollectionViewCell")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setupJobListCollectionView()
        setupNavigationBar()
        
        viewModel = JobInfoViewModel(repository: repository)
        Task {
            await viewModel.trigger(query: .fileName)
            
            viewModel.jobListInfo.bind { [self] _ in
                self.jobList = viewModel.fetchJobGroup()
                
                DispatchQueue.main.async {
                    self.jobListCollectionView.reloadData()
                }
            }
        }
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
    
    private func setupNavigationBar() {
        navigationItem.title = "직업 소개"
        navigationItem.largeTitleDisplayMode = .automatic
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "직업 이름을 입력하세요."
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        
        navigationItem.searchController = searchController
    }
}

//MARK: - JobListViewController SearchController Delegate

extension JobListViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        //TODO: 이부분은 뷰모델 필터링 메서드 호출하는걸로 변경해야함.
        Task {
            await self.viewModel.searchJob(text)
        }
    }
}

//MARK: - JobListCollectionView delegate, datasource
extension JobListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobListCollectionViewCell", for: indexPath) as? JobListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setupCellImage(title: jobList[indexPath.section].jobs[indexPath.row].jobImage)
        
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

            headerView.setupTitle(title: jobList[indexPath.section].jobGroupTitle)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return jobList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobList[section].jobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var index = indexPath.item
        
        for section in 0..<indexPath.section {
            index += collectionView.numberOfItems(inSection: section)
        }
        
        self.viewModel.selectJob(index)
        let detailViewController = JobDetailCollectionViewController(viewModel: self.viewModel)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

//MARK: - Mock Data
struct JobGroup {
    let jobGroupTitle: String
    let jobs: [Job]
}

struct Job {
    let title: String
    let jobImage: String
}
