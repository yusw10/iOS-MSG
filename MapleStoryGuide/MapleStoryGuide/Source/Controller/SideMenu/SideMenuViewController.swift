//
//  SideMenuViewController.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/02/01.
//

import UIKit
import Then
import SideMenu

enum SideMenuList: String, CaseIterable {
    case mapleDictionary = "mapleDictionary"
    case equipmentCalc = "equipmentCalc"
    case itemCombination = "itemCombination"
}

final class SideMenuViewController: UIViewController {
    
    //MARK: - ViewController Properties
    
    private var sideMenuItems: [SideMenuItem] = []
    weak var delegate: SideMenuDelegate?
    
    private let sideMenuMainTitle = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title2)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Maple Story Guide"
    }
    
    private let menuTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupMainTitle()
        setupTableView()
        print("side menu load")
    }
    
    //MARK: - ViewController Initializer
    
    convenience init(sideMenuItems: [SideMenuItem]) {
        self.init()
        self.sideMenuItems = sideMenuItems
    }
    
    //MARK: - ViewController SetupMethod
    
    private func setupMainTitle() {
        view.addSubview(sideMenuMainTitle)
        
        sideMenuMainTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
    }
    
    private func setupTableView() {
        view.addSubview(menuTableView)
        menuTableView.snp.makeConstraints { make in
            make.top.equalTo(sideMenuMainTitle.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(5)
            make.trailing.bottom.equalToSuperview().offset(-5)
        }
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.register(SideMenuTableViewCell.self, forCellReuseIdentifier: "menuCell")
    }
    
    func hide() {
        dismiss(animated: true)
    }
}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sideMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as? SideMenuTableViewCell else {
            return UITableViewCell()
        }
        let item = sideMenuItems[indexPath.row]
        cell.setupCellData(title: item.name, imageName: item.icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item = sideMenuItems[indexPath.row]
        delegate?.itemSelected(item: item.viewController)
    }
}
