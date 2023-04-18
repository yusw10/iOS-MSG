//
//  ItemDetailViewController.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/03/24.
//

import UIKit
import SnapKit
import Then

// MARK: Controller
class ItemDetailViewController: ContentViewController, UITableViewDelegate {
    enum Section {
        case mainSection
    }
    
    private let viewModel: BossInfoViewModel
    
    private let itemDetailView = ItemDetailView()
    private lazy var diffableDataSource: UITableViewDiffableDataSource<Section, RewardItem> = .init(tableView: itemDetailView.tableView) { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ItemDescriptionCell.id,
            for: indexPath
        ) as? ItemDescriptionCell else { return nil }
        
        cell.configureCell(item: itemIdentifier)
        return cell
    }
    
    init(viewModel: BossInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = itemDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNav()
        applySnapshot()
        itemDetailView.tableView.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.isMovingFromParent {
            var snapshot = self.diffableDataSource.snapshot()
            snapshot.deleteAllItems()
            diffableDataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    private func configureNav() {
        self.navigationItem.title = "아이템 설명"
    }
    
    private func applySnapshot() {
        let item = self.viewModel.filterItem()
        
        var snapshot = diffableDataSource.snapshot()
        snapshot.appendSections([.mainSection])
        snapshot.appendItems(item)
        
        diffableDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}


// MARK: View
class ItemDetailView: UIView {
    let tableView = UITableView().then { tableView in
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 100
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        setLayout()
        registerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubView() {
        self.addSubview(tableView)
    }
    
    private func setLayout() {
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self)
        }
    }
    
    private func registerCell() {
        self.tableView.register(
            ItemDescriptionCell.self,
            forCellReuseIdentifier: ItemDescriptionCell.id
        )
    }
}


// MARK: Cell
class ItemDescriptionCell: UITableViewCell {
    static let id = "ItemDescriptionCell"
    
    private let itemImageView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let titlelabel = UILabel().then { label in // label font 사이즈 설정
        label.textAlignment = .left
        label.font = .MapleTitleFont()
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let descriptionLabel = UILabel().then { label in
        label.textAlignment = .left
        label.font = .MapleLightFont()
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let labelVerticalStackView = UIStackView().then { stackView in
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(item: RewardItem) {
        guard let url = URL(string: item.imageURL) else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        self.titlelabel.text = item.name
        self.descriptionLabel.text = item.description
        
        Task {
            await self.itemImageView.fetchImage(request)
        }
    }
    
    private func addSubView() {
        self.contentView.addSubview(itemImageView)
        self.contentView.addSubview(labelVerticalStackView)
        
        self.labelVerticalStackView.addArrangedSubview(titlelabel)
        self.labelVerticalStackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setLayout() {
        itemImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.leading.equalTo(self.contentView).offset(10)
            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.15)
            make.height.equalTo(self.itemImageView.snp.width)
        }
        
        labelVerticalStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.itemImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-20)
            make.top.equalTo(self.contentView.snp.top).offset(10)
            make.centerY.equalTo(self.itemImageView.snp.centerY)
        }
    }
}
