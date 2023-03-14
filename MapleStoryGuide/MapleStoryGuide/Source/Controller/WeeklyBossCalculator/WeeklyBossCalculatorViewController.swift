//
//  WeeklyBossCalculatorViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/14.
//

import UIKit
import SnapKit

final class WeeklyBossCalculatorViewController: ContentViewController {
    
    private let weeklyBossCalculatorCollectionViewController = WeeklyBossCalculatorCollectionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
    }
    
}

private extension WeeklyBossCalculatorViewController {
    
    func setupView() {
        self.view.addSubview(weeklyBossCalculatorCollectionViewController.collectionView)
    }
    
    func setupLayout() {
        weeklyBossCalculatorCollectionViewController.collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.view)
        }
    }
    
}
