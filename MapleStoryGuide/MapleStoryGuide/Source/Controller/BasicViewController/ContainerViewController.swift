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
    private var rootViewController: Contentable! {
        didSet {
            if let contenViewController = rootViewController as? ContentViewController {
                contenViewController.delegate = self
                navigator.setViewControllers([contenViewController], animated: false)
            } else if let contentMyCharacterListViewController = rootViewController as? ContentMyCharacterListViewController {
                contentMyCharacterListViewController.delegate = self
                navigator.setViewControllers([contentMyCharacterListViewController], animated: false)
            }
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
        if let contentViewController = rootViewController as? ContentViewController {
            contentViewController.delegate = self
        } else if let contentMyCharacterListViewController = rootViewController as? ContentMyCharacterListViewController {
            contentMyCharacterListViewController.delegate = self
        }
    }
    
    func updateRootViewController(_ viewController: Contentable) {
        if let contentViewController = viewController as? ContentViewController {
            contentViewController.containerViewController = self
            rootViewController = contentViewController
        } else if let contentMyCharacterListViewController = viewController as? ContentMyCharacterListViewController {
            contentMyCharacterListViewController.containerViewController = self
            rootViewController = contentMyCharacterListViewController
        }
       
    }
    
    private func addChildViewControllers() {
        addChild(navigator)
        view.addSubview(navigator.view)
        navigator.didMove(toParent: self)
    }
    
    func pushViewController(_ viewController: ContentViewController) {
        viewController.containerViewController = self
        viewController.delegate = self
        navigator.pushViewController(viewController, animated: true)
    }
    
    func pushCollectionViewController(_ viewController: ContentCollectionViewController) {
        viewController.containerViewController = self
        viewController.delegate = self
        navigator.pushViewController(viewController, animated: true)
    }
    
    func pushTableViewController(_ viewController: ContentTableViewController) {
        viewController.containerViewController = self
        viewController.delegate = self
        navigator.pushViewController(viewController, animated: true)
    }
    
    func pushListViewController(_ viewController: ContentMyCharacterListViewController) {
        viewController.containerViewController = self
        viewController.delegate = self
        navigator.pushViewController(viewController, animated: true)
    }
    
}

extension ContainerViewController: SideMenuDelegate {
    func configureOpacity(state: Bool) {
        if state {
            self.navigator.topViewController!.view.layer.opacity = 0.6
        } else {
            self.navigator.topViewController!.view.layer.opacity = 1.0
        }
    }
    
    func menuButtonTapped() {
        let sideMenuNavigationController = SideMenuNavigationController(rootViewController: sideMenuViewController)
        sideMenuNavigationController.presentationStyle = .menuSlideIn
        sideMenuViewController.setState(true)
        present(sideMenuNavigationController, animated: true)
    }
    
    func itemSelected(item: ContentViewControllerPresentation) {
        switch item {
        case let .embed(viewController):
            if let contentViewController = viewController as? ContentViewController {
                updateRootViewController(contentViewController)
            } else if let contentMyCharacterListViewController = viewController as? ContentMyCharacterListViewController {
                updateRootViewController(contentMyCharacterListViewController)
            }
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
