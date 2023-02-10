//
//  ContainerViewController.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/02/07.
//

import UIKit
import SideMenu

final class ContainerViewController: UIViewController {
    
    private var sideMenuViewController: SideMenuViewController!
    
    private var navigator: UINavigationController!
    private var rootViewController: ContentViewController! {
        didSet {
            rootViewController.delegate = self
            navigator.setViewControllers([rootViewController], animated: false)
        }
    }

    convenience init(sideMenuViewController: SideMenuViewController, rootViewController: ContentViewController) {
        self.init()
        self.sideMenuViewController = sideMenuViewController
        self.rootViewController = rootViewController
        self.navigator = UINavigationController(rootViewController: rootViewController)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        addChildViewControllers()
        configureDelegates()
    }

    private func configureDelegates() {
        sideMenuViewController.delegate = self
        rootViewController.delegate = self
    }

    func updateRootViewController(_ viewController: ContentViewController) {
        rootViewController = viewController
    }

    private func addChildViewControllers() {
        addChild(navigator)
        view.addSubview(navigator.view)
        navigator.didMove(toParent: self)
    }
}

extension ContainerViewController: SideMenuDelegate {
    func menuButtonTapped() {
        let sideMenuNavigationController = SideMenuNavigationController(rootViewController: sideMenuViewController)
        sideMenuNavigationController.presentationStyle = .menuSlideIn
        present(sideMenuNavigationController, animated: true)
    }

    func itemSelected(item: ContentViewControllerPresentation) {
        switch item {
        case let .embed(viewController):
            updateRootViewController(viewController)
            sideMenuViewController.hide()
        case let .push(viewController):
            sideMenuViewController.hide()
            navigator.pushViewController(viewController, animated: true)
        case let .modal(viewController):
            sideMenuViewController.hide()
            navigator.present(viewController, animated: true, completion: nil)
        }
    }
}
