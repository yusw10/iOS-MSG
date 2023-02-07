//
//  EquipmentCalcViewController.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/02/05.
//

import UIKit
import SideMenu

final class EquipmentCalcViewController: ContentViewController {
    
    var menu: SideMenuNavigationController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemMint
        setupSideMenu()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let rightBarButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(didTapMenu))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupSideMenu() {
        menu = SideMenuNavigationController(rootViewController: SideMenuViewController())
        menu?.leftSide = true
        menu?.presentationStyle = .menuSlideIn
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    //MARK: - @objc Method
    
    @objc private func didTapMenu() {
        guard let menu = menu else {
            return
        }
        
        present(menu, animated: true)
    }
}
