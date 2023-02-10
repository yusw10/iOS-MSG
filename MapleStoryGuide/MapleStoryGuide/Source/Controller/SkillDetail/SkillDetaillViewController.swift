//
//  SkillDetaillViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/02/02.
//

import UIKit
import SnapKit

final class SkillDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let skillDetailView = SkillDetailView()
    
    // MARK: - App LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        addSubViews()
        setLayouts()
    }
    
    // MARK: - Methods
    
    func configure(image: UIImage, title: String, description: String) {
        skillDetailView.configure(image: image, title: title, description: description)
    }
    
}

// MARK: - Private Methods

extension SkillDetailViewController {
    
    private func addSubViews() {
        self.view.addSubview(skillDetailView)
    }
    
    private func setLayouts() {
        skillDetailView.snp.makeConstraints { make in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.right.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
}
