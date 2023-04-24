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
    
    let bannerShadowView = UIView().then {
        $0.layer.shadowOffset = CGSize(width: 5, height: 5)
        $0.layer.shadowOpacity = 0.7
        $0.layer.shadowRadius = 5

        $0.layer.shadowColor = UIColor.gray.cgColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let bannerImage = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
    }
    
    //MARK: - CollectionViewCell Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefault()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        debugPrint("MainCollectionViewCell - Initialize Error")
    }
    
    //MARK: - CollectionViewCell Setup Method
    
    private func setupDefault() {
        contentView.addSubview(bannerShadowView)
        bannerShadowView.addSubview(bannerImage)
        
        bannerShadowView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide.snp.edges)
        }
        
        bannerImage.snp.makeConstraints({ make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide.snp.edges)
        })
    }
    
    func setupCellImage(title: String) {
        bannerImage.image = UIImage(named: title)
    }
}
