//
//  AppDelegate.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/01/31.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        URLCache.shared = URLCache(
            memoryCapacity: 0,
            diskCapacity: 200 * 1024 * 1024,
            diskPath: nil
        )
        requestUserNotification()
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController as? ContainerViewController else { return }
        
        if response.notification.request.identifier == "bossAlert" {
            let weeklyBossCharacterListViewController = WeeklyBossCharacterListViewController()
            rootViewController.pushListViewController(weeklyBossCharacterListViewController)
        }
    }
    
    private func requestUserNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { didAllow, error in
            if didAllow {
                return
            }
        }
    }
}
