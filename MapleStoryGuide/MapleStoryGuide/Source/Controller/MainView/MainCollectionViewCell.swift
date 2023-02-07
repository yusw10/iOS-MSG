//
//  MainCollectionViewCell.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/02/03.
//

import UIKit
import Then
import SnapKit

final class MainCollectionViewCell: UICollectionViewCell {
    
    //MARK: - CollectionViewCell Properties
    
    let bannerImage = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
    }
    
    //MARK: - CollectionViewCell Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        setupDefault()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        debugPrint("MainCollectionViewCell - Initialize Error")
    }
    
    //MARK: - CollectionViewCell Setup Method
    
    private func setupDefault() {
        contentView.addSubview(bannerImage)
        
        bannerImage.snp.makeConstraints({ make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide.snp.edges)
        })
    }
    
    func setupCellImage(title: String) {
        bannerImage.image = UIImage(named: title)
    }
}
