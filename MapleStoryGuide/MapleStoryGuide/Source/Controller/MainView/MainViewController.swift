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
        addUserNotification()
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
    
    private func addUserNotification() {
        let content = UNMutableNotificationContent()
        content.title = "주간 보스 알림"
        content.body = "주간 보스 초기화 하루 전날입니다."
        
        var dateComponents = DateComponents()
        dateComponents.weekday = 3
        dateComponents.hour = 11
        dateComponents.minute = 06
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "bossAlert", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
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
            let bossListViewController = BossListViewController()
            containerViewController?.pushViewController(bossListViewController)
        case .bossInfo:
            let weeklyBossCalculatorViewController = WeeklyBossCharacterListViewController()
            containerViewController?.pushListViewController(weeklyBossCalculatorViewController)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(30)
    }
}
