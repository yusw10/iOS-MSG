//
//  ViewController.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/01/31.
//
import UIKit
import Then
import SnapKit

final class MainViewController: ContentViewController {
    
    enum MainViewBannerList: String, CaseIterable {
        case jobList = "jobList"
        case bossInfo = "bossInfo"
        case weeklyBossCheckList = "weeklyBossCheckList"
        case webViewInfo = "webViewInfo"
    }
    
    //MARK: - ViewController Properies
    
    private var mainViewBannerList = MainViewBannerList.allCases
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<MainViewBannerList, AnyHashable>! = nil
    private lazy var mainCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.setupCompositionalLayout()
    ).then {
        $0.delegate = self
        $0.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "mainCollectionViewCell")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - View Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupMainCollectionView()
        setupDiffableDataSource()
        addUserNotification()
    }
    
    //MARK: - ViewController Setup Method
    
    private func setupNavigationController() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.MapleLightFont()]
        navigationItem.title = "MapleStory Guide"
    }
    
    private func setupMainCollectionView() {
        view.addSubview(mainCollectionView)
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupDiffableDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<MainViewBannerList, AnyHashable>(collectionView: self.mainCollectionView, cellProvider: { (collectionView, indexPath, object) -> UICollectionViewCell in
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "mainCollectionViewCell",
                for: indexPath
            ) as! MainCollectionViewCell
            cell.setupCellImage(title: self.mainViewBannerList[indexPath.row].rawValue)
            
            return cell
        })
        var snapshot = self.diffableDataSource.snapshot()
        snapshot.appendSections([.jobList])
        snapshot.appendItems(self.mainViewBannerList, toSection: .jobList)
        
        diffableDataSource.apply(snapshot)
    }
    
    private func setupCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        item.contentInsets.leading = 15
        item.contentInsets.trailing = 15
        item.contentInsets.bottom = 30
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(200)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func addUserNotification() {
        let content = UNMutableNotificationContent()
        content.title = "주간 보스 알림"
        content.body = "주간 보스 초기화 하루 전날입니다."
        
        var dateComponents = DateComponents()
        dateComponents.weekday = 4 // 매주 수요일
        dateComponents.hour = 12 // 12시
        dateComponents.minute = 30 // 30분
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "bossAlert", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
}

// MARK: - MainCollectionView Delegate

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBanner = mainViewBannerList[indexPath.row]
        
        switch selectedBanner {
        case .jobList:
            let jobListViewController = JobListViewController()
            containerViewController?.pushViewController(jobListViewController)
        case .bossInfo:
            let bossListViewController = BossListViewController()
            containerViewController?.pushViewController(bossListViewController)
        case .weeklyBossCheckList:
            let weeklyBossCalculatorViewController = WeeklyBossCharacterListViewController()
            containerViewController?.pushListViewController(weeklyBossCalculatorViewController)
        case .webViewInfo:
            let webViewListController = WebViewListViewController()
            containerViewController?.pushViewController(webViewListController)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(30)
    }
    
}
