//
//  WebViewListViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/04/10.
//

import UIKit

final class WebViewListViewController: ContentViewController {
    
    struct WebInfo: Hashable {
        let name: String
        let description: String
        let pageURL: String
    }
    
    enum Section {
        case main
    }
        
    private let webInfo: [WebInfo] = [
        WebInfo(
            name: "메이플 이벤트 공식 홈페이지",
            description: "메이플스토리 진행중인 이벤트 목록 입니다.",
            pageURL: "https://m.maplestory.nexon.com/News/Event"
        ),
        WebInfo(
            name: "메이플 GG",
            description: "메이플스토리를 위한 종합통계 사이트 입니다.",
            pageURL: "https://maple.gg/"
        ),
        WebInfo(
            name: "큐브매수통",
            description: "큐브 시뮬레이터를 돌려 예상 금액을 알아보는 사이트 입니다.",
            pageURL: "https://cubemesu.co/"
        ),
        WebInfo(
            name: "mesu.live",
            description: "스타포스 시뮬레이터를 돌려 예상 금액을 알아보는 사이트 입니다.",
            pageURL: "https://mesu.live/sim/starforce"
        ),
        WebInfo(
            name: "메이플 인벤",
            description: "메이플스토리 인벤 커뮤니티 입니다.",
            pageURL: "https://maple.inven.co.kr/"
        )
    ]
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: setupCollectionViewLayout()
    ).then { collectionView in
        collectionView.delegate = self
        collectionView.register(
            WebViewListCell.self,
            forCellWithReuseIdentifier: WebViewListCell.id
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Section, WebInfo> = .init(
        collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewCell in
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WebViewListCell.id,
            for: indexPath
        ) as? WebViewListCell else { return UICollectionViewCell() }
        
        cell.configure(
            title: object.name,
            description: object.description
        )
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = collectionView
        updateUI()
        setupNavitaionBar()
    }
    
    func updateUI() {
        var snapshot = self.diffableDataSource.snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(webInfo, toSection: .main)

        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func setupCollectionViewLayout() -> UICollectionViewLayout {
        let layoutConfig = UICollectionLayoutListConfiguration(
            appearance: .plain
        )
        
        let listLayout = UICollectionViewCompositionalLayout.list(
            using: layoutConfig
        )
        
        return listLayout
    }
    
    func setupNavitaionBar() {
        navigationItem.title = "유용한 사이트 모음"
    }
    
}

extension WebViewListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let webViewController = WebViewController(url: webInfo[indexPath.row].pageURL)
        
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
}


