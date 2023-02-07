//
//  JobListCollectionViewCell.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/02/06.
//

import UIKit
import Then
import SnapKit

final class JobListCollectionViewCell: UICollectionViewCell {
    
    //MARK: - CollectionViewCell Properties
    
    let jobImage = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
    }
    
    //MARK: - CollectionViewCell Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemPink
        setupDefault()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        debugPrint("JobListCollectionViewCell - Initialize Error")
    }
    
    //MARK: - CollectionViewCell Setup Method
    
    private func setupDefault() {
        contentView.addSubview(jobImage)
        
        jobImage.snp.makeConstraints({ make in
            make.top.leading.bottom.trailing.equalTo(contentView)
        })
    }
    
    func setupCellImage(title: String) {
        jobImage.image = UIImage(named: title)
    }
}
