//
//  WeeklyBossCalculatorViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/14.
//

import UIKit
import SnapKit
import Then

final class WeeklyBossCalculatorViewController: ContentViewController {
    
    private let weeklyBossCalculatorCollectionViewController = WeeklyBossCalculatorCollectionViewController()
    
    private lazy var addButton = UIButton().then {
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
        $0.backgroundColor = .systemBrown
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        setupButton()
    }
    
}

private extension WeeklyBossCalculatorViewController {
    
    func setupView() {
        self.view.addSubview(weeklyBossCalculatorCollectionViewController.collectionView)
        self.view.addSubview(addButton)
    }
    
    func setupLayout() {
        weeklyBossCalculatorCollectionViewController.collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.view)
        }
        
        addButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self.view).inset(20)
            
            make.width.height.equalTo(self.view.snp.width).multipliedBy(0.2)
        }
    }
    
    func setupButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        
        addButton.tintColor = .white
        addButton.setImage(image, for: .normal)
        
        addButton.addTarget(self, action: #selector(TappedAddButton), for: .touchUpInside)
    }
    
    @objc func TappedAddButton() {
        let alert = UIAlertController(
            title: "캐릭터 등록",
            message: "닉네임과 월드를 기입해주세요.",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "닉네임"
        }
        alert.addTextField { textField in
            textField.placeholder = "월드"
        }
        
        let ok = UIAlertAction(
            title: "OK",
            style: .default
        ) { (ok) in
            
        }
        
        let cancel = UIAlertAction(
            title: "cancel",
            style: .cancel
        ) { (cancel) in
            
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
