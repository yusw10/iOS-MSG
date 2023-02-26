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
    private let repository = AssetJobInfoRepository()
    private var viewModel: JobInfoViewModel! = nil
    private var prefetchTask: Task<Void, Never>?
    private var jobList = [JobGroup]()
    private var selectedSection = 0
    private var selectedRow = 0

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
        viewModel.jobListInfo.subscribe(on: self) { [self] _ in
            self.jobList = viewModel.fetchJobGroup()
            
            DispatchQueue.main.async {
                self.jobListCollectionView.reloadData()
            }
        }
        
        Task {
            await viewModel.trigger(query: .newJson)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            viewModel.jobListInfo.unsunscribe(observer: self)
            ImageCacheManager.shared.cacheManger.removeAllObjects()
        }
    }
    
    //MARK: - ViewController Private method
    
    private func setupJobListCollectionView() {
        jobListCollectionView.delegate = self
        jobListCollectionView.dataSource = self
        jobListCollectionView.prefetchDataSource = self
        
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
        
        let url = jobList[indexPath.section].jobs[indexPath.item].imageURL
        if let image = ImageCacheManager.shared.getCachedImage(url: url)?.downSampling(for: cell.jobImage.bounds.size) {
            cell.setupImage(by: image)
        } else {
            cell.setupCellImage(title: jobList[indexPath.section].jobs[indexPath.item].imageURL)
        }
        
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

            headerView.setupTitle(title: jobList[indexPath.section].type)
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
        
        self.selectedSection = indexPath.section
        self.selectedRow = indexPath.row
        let detailViewController = JobDetailCollectionViewController(viewModel: self.viewModel)
        detailViewController.delegate = self
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension JobListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let imageCache = ImageCacheManager.shared
        
        prefetchTask = Task {
            for indexPath in indexPaths {
                let url = jobList[indexPath.section].jobs[indexPath.row].imageURL
                guard let image = await UIImage.fetchImage(from: url) else { return }
                if imageCache.getCachedImage(url: url) == nil {
                    imageCache.saveCache(image: image, url: url)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        prefetchTask?.cancel()
    }
}

extension JobListViewController: JobDetailControllerDelegate {
    func selectJobDetail() {
        self.viewModel.selectJob(selectedSection, selectedRow)
    }
}
