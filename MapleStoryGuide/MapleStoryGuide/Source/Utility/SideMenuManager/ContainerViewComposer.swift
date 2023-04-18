//
//  SideMenuManager.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/02/07.
//

import UIKit

protocol Contentable { }

final class ContainerViewComposer {
    static func makeContainer() -> ContainerViewController {
        let mainViewController = MainViewController()
        let jobListViewController = JobListViewController()
        let bossListViewController = BossListViewController()
        let weeklyBossCharacterListViewController = WeeklyBossCharacterListViewController()
        let webViewListViewController = WebViewListViewController()
        
        let sideMenuItems = [
            SideMenuItem(icon: "house.fill",
                         name: "  메인 화면",
                         viewController: .embed(mainViewController)),
            SideMenuItem(icon: "info.circle",
                         name: "  직업 소개 화면",
                         viewController: .embed(jobListViewController)),
            SideMenuItem(icon: "info.circle",
                         name: "  보스 소개 화면",
                         viewController: .embed(bossListViewController)),
            SideMenuItem(icon: "highlighter",
                         name: "  주간 보스 체크 리스트",
                         viewController: .embed(weeklyBossCharacterListViewController)),
            SideMenuItem(icon: "list.dash",
                         name: "  유용한 사이트",
                         viewController: .embed(webViewListViewController)),
        ]
        let sideMenuViewController = SideMenuViewController(sideMenuItems: sideMenuItems)
        let container = ContainerViewController(sideMenuViewController: sideMenuViewController,
                                                rootViewController: mainViewController)
        
        return container
    }
}
