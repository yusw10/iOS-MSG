//
//  JobImageViewCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/02/02.
//

import UIKit
import SnapKit
import Then

final class JobImageViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let id = "JobImageViewCell"
    
    let imageView = UIImageView().then {
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        setLayouts()
        setCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.prepare(image: nil)
    }
    
    func prepare(image: UIImage?) {
        self.imageView.image = image
    }
    
}

// MARK: - Private Methods

extension JobImageViewCell {
    
    // MARK: - Add View, Set Layout
    
    private func addSubViews() {
        self.contentView.addSubview(imageView)
    }
    
    private func setLayouts() {
        imageView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(self.contentView)
        }
    }
    
    // MARK: - Set Cell Layout
    
    private func setCellLayout() {
        self.contentView.backgroundColor = .white
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: self.contentView.layer.cornerRadius
        ).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
        
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 15
    }
}
