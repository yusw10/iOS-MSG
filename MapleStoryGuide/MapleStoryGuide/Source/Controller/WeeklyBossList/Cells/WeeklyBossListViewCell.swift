//
//  WeeklyBossListViewCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/16.
//

import UIKit
import SnapKit
import Then

final class WeeklyBossListViewCell: UICollectionViewListCell {
    
    static let id = "WeeklyBossListViewCell"
    
    private lazy var horizontalStackView = UIStackView().then {
        $0.alignment = .center
        $0.spacing = 10
        $0.axis = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var subHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var bossName = UILabel().then {
        $0.font = .preferredFont(
            forTextStyle: .title3,
            compatibleWith: UITraitCollection(legibilityWeight: .bold)
        )
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var bossDifficulty = UILabel().then {
        $0.textAlignment = .left
        $0.font = .preferredFont(
            forTextStyle: .title3,
            compatibleWith: UITraitCollection(legibilityWeight: .bold)
        )
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var bossCrystalStone = UILabel().then {
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var verticalStackView = UIStackView().then {
        $0.spacing = 10
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var clearCheckSwitch = UISwitch().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(bossName: String, bossDifficulty: String, thumnailImageURL: String, bossCrystalStone: String, bossClear: Bool) {
        self.bossName.text = "\(bossName) (\(bossDifficulty). 2인)"
        self.bossDifficulty.text = nil
        self.bossDifficulty.isHidden = true
        self.bossCrystalStone.text = bossCrystalStone.insertComma
        self.clearCheckSwitch.isOn = bossClear
        
        let request = URLRequest(url: URL(string: thumnailImageURL)!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = UIImage(systemName: "xmark.circle")
                    self.thumbnailImageView.contentMode = .scaleAspectFit
                }
                return
            }
            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
            }
        }
        task.resume()
    }
    
}

private extension WeeklyBossListViewCell {
    
    func setupView() {
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(horizontalStackView)
        
        [thumbnailImageView, verticalStackView, clearCheckSwitch].forEach { view in
            horizontalStackView.addArrangedSubview(view)
        }
        
        [bossName, bossDifficulty].forEach { view in
            subHorizontalStackView.addArrangedSubview(view)
        }
        
        [subHorizontalStackView, bossCrystalStone].forEach { view in
            verticalStackView.addArrangedSubview(view)
        }
    }
    
    func setupLayout() {
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.contentView).inset(10)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.25)
            make.height.equalTo(self.contentView.snp.width).multipliedBy(0.2)
        }
        
        clearCheckSwitch.snp.makeConstraints { make in
            make.trailing.equalTo(horizontalStackView.snp.trailing)
        }
    }

}
