//
//  ContentViewController.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/02/07.
//

import UIKit

protocol ContentViewControllerSetup {
    func configureView()
}

enum ViewControllerType {
    case viewController
    case collectionViewController
    case tableViewController
}

class ContentViewController: UIViewController, ContentViewControllerSetup {
    
    weak var delegate: SideMenuDelegate?
    weak var containerViewController: ContainerViewController?
    var barButtonImage: UIImage? = UIImage(systemName: "line.horizontal.3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        let barButtonItem = UIBarButtonItem(image: barButtonImage, style: .plain, target: self, action: #selector(menuTapped))
        barButtonItem.tintColor = .black
        navigationItem.setRightBarButton(barButtonItem, animated: false)
    }
    
    @objc private func menuTapped() {
        delegate?.menuButtonTapped()
    }
}

class ContentCollectionViewController: UICollectionViewController, ContentViewControllerSetup {
    
    weak var delegate: SideMenuDelegate?
    weak var containerViewController: ContainerViewController?
    var barButtonImage: UIImage? = UIImage(systemName: "line.horizontal.3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        let barButtonItem = UIBarButtonItem(image: barButtonImage, style: .plain, target: self, action: #selector(menuTapped))
        barButtonItem.tintColor = .black
        navigationItem.setRightBarButton(barButtonItem, animated: false)
    }
    
    @objc private func menuTapped() {
        delegate?.menuButtonTapped()
    }
}

class ContentTableViewController: UITableViewController, ContentViewControllerSetup {
    
    weak var delegate: SideMenuDelegate?
    weak var containerViewController: ContainerViewController?
    var barButtonImage: UIImage? = UIImage(systemName: "line.horizontal.3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        let barButtonItem = UIBarButtonItem(image: barButtonImage, style: .plain, target: self, action: #selector(menuTapped))
        barButtonItem.tintColor = .black
        navigationItem.setRightBarButton(barButtonItem, animated: false)
    }
    
    @objc private func menuTapped() {
        delegate?.menuButtonTapped()
    }
}
