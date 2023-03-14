//
//  ViewController.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/01/31.
//
import UIKit
import Then
import SnapKit

enum MainViewBannerList: String, CaseIterable {
    case jobList = "jobList"
    case additionalOption = "additionalOption"
    case bossInfo = "bossInfo"
}

final class MainViewController: ContentViewController {
    
    //MARK: - ViewController Properies
        
    private var mainViewBannerList = MainViewBannerList.allCases
    
    private let mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "mainCollectionViewCell")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - View Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMainCollectionView()
    }
    
    //MARK: - ViewController Setup Method
    
    private func setupMainCollectionView() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        view.addSubview(mainCollectionView)
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - MainCollectionView Delegate, DataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mainViewBannerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setupCellImage(title: mainViewBannerList[indexPath.row].rawValue)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 80 , height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBanner = mainViewBannerList[indexPath.row]
        
        switch selectedBanner {
        case .jobList:
            let jobListViewController = JobListViewController()
            containerViewController?.pushViewController(jobListViewController)
        case .additionalOption:
            print("push additionalOptionViewController")
        case .bossInfo:
            let weeklyBossCalculatorViewController = WeeklyBossCalculatorViewController()
            containerViewController?.pushViewController(weeklyBossCalculatorViewController)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(30)
    }
}
