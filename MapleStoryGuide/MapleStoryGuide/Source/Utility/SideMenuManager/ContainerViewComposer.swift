//
//  SideMenuManager.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/02/07.
//

import UIKit

final class ContainerViewComposer {
    static func makeContainer() -> ContainerViewController {
        let mainViewController = MainViewController()
        let equipmentCalcViewController = EquipmentCalcViewController()
        let itemCombinationViewController = ItemCombinationViewController()
        let sideMenuItems = [
            SideMenuItem(icon: "house.fill",
                         name: "main",
                         viewController: .embed(mainViewController)),
            SideMenuItem(icon: "gear",
                         name: "equipment",
                         viewController: .embed(equipmentCalcViewController)),
            SideMenuItem(icon: "info.circle",
                         name: "itemCombination",
                         viewController: .push(itemCombinationViewController))
        ]
        let sideMenuViewController = SideMenuViewController(sideMenuItems: sideMenuItems)
        let container = ContainerViewController(sideMenuViewController: sideMenuViewController,
                                                rootViewController: mainViewController)

        return container
    }
}
