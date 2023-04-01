//
//  WeeklyBossListViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/16.
//

import UIKit
import SnapKit
import Then

// TODO: CoreData쪽 연결
// TODO: 코드 일관성

final class WeeklyBossCalculatorViewController: UIViewController {
 
    enum Section: CaseIterable {
        case main
    }
    
    private var viewModel: WeeklyBossCharacterListViewModel
    private var selectedIndex: Int

    private let tableView = UITableView(
        frame: .zero,
        style: .plain
    ).then { tableView in
        tableView.register(
            WeeklyBossCalculatorViewCell.self,
            forCellReuseIdentifier: WeeklyBossCalculatorViewCell.id
        )
        tableView.rowHeight = 70
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var totalPriceLabel = UILabel().then {
        $0.font = .preferredFont(
            forTextStyle: .title2,
            compatibleWith: UITraitCollection(legibilityWeight: .bold)
        )
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    private lazy var diffableDataSource: UITableViewDiffableDataSource<Section, MyWeeklyBoss> = .init(tableView: self.tableView) { [self] (tableView, indexPath, object) -> UITableViewCell? in
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: WeeklyBossCalculatorViewCell.id,
            for: indexPath
        ) as! WeeklyBossCalculatorViewCell
        
        cell.configureCell(name: object.name)
        cell.checkButton.setCheckState(state: object.checkClear)
        cell.checkButton.addTarget(
            self,
            action: #selector(self.didTapCheckButton(sender:)),
            for: .touchUpInside
        )

        return cell
    }
    
    init(
        viewModel: WeeklyBossCharacterListViewModel,
        selectedIndex: Int
    ) {
        self.viewModel = viewModel
        self.selectedIndex = selectedIndex
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        setupView()
        setupLayout()
        
        viewModel.selectedCharacter.subscribe(on: self) { [weak self] information in
            self?.applySnapShot(from: information!)
        }
        viewModel.selectCharacter(index: selectedIndex)
        setupNavigation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.viewModel.selectedCharacter.unsunscribe(observer: self)
    }
}

private extension WeeklyBossCalculatorViewController {
    func setupNavigation() {
        navigationItem.title = viewModel.selectedCharacter.value?.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "보스 추가",
            style: .plain,
            target: self,
            action: #selector(didTapAddBossButton)
        )
    }
    
    func setupView() {
        self.view.addSubview(tableView)
    }
    
    func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.view)
        }
    }
    
    func applySnapShot(from data: MyCharacter) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MyWeeklyBoss>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data.bossInformations)
        
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension WeeklyBossCalculatorViewController: WeelyBossAddViewDelegate {
    func weelyBossAdd(from data: WeeklyBossInfo) {
        let data = MyWeeklyBoss(
            checkClear: false,
            name: data.name,
            thumnailImageURL: data.imageURL
        )
        
        viewModel.characterInfo.value[selectedIndex].bossInformations.append(data)
        viewModel.selectedCharacter.value?.bossInformations.append(data)
    }
}

extension WeeklyBossCalculatorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextualAction = UIContextualAction(style: .normal, title: "delete") { (action, view, handler) in
            self.viewModel.selectedCharacter.value?.bossInformations.remove(at: indexPath.row)
        }
        contextualAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(
            actions: [contextualAction]
        )
    }
}

@objc private extension WeeklyBossCalculatorViewController {
    func didTapAddBossButton() {
        // MARK: Modal 방식으로 변경 (연락처 앱을 확인해보면 뭔가를 추가하는 방식은 대부분 모달 방식으로 동작)
        let weeklyBossAddViewController = WeeklyBossAddViewController()
        weeklyBossAddViewController.delegate = self
        
        present(weeklyBossAddViewController, animated: true)
    }
    
    func didTapCheckButton(sender: CheckBox) {
        if sender.getCheckState() {
            sender.setCheckState(state: false)
        } else {
            sender.setCheckState(state: true)
        }
    }
}
