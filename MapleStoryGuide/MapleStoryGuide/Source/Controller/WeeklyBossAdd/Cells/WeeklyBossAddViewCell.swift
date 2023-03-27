//
//  WeeklyBossAddViewCell.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/23.
//

import UIKit
import SnapKit
import Then

final class WeeklyBossAddViewCell: UICollectionViewListCell {
   
    static let id = "WeeklyBossAddViewCell"

    weak var viewController: UIViewController?

    var bossList: BossList?
    var characterInfo: CharacterInfo?

    private var bossDifficultyList = [String]()
    private var bossPriceList = [String]()
    private var choiceBossDifficulty = ""
    private var choiceBossPrice = ""
        
    private lazy var worldPickerView = UIPickerView(
        frame: CGRect(x: 5, y: 30, width: 260, height: 100)
    )
    
    private lazy var bossListAddButton = UIButton().then {
        $0.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        $0.tintColor = .systemGreen
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var checkmarkImageView = UIImageView().then {
        $0.isHidden = true
        $0.tintColor = .systemGreen
        $0.image = UIImage(systemName: "checkmark.circle")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
        setupPickerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(bossList: BossList, characterInfo: CharacterInfo) {
        self.bossList = bossList
        self.characterInfo = characterInfo
        self.bossDifficultyList = bossList.difficulty
        self.bossPriceList = bossList.price
        choiceBossDifficulty = bossDifficultyList[0]
        choiceBossPrice = bossPriceList[0]

        let request = URLRequest(url: URL(string: bossList.thumnailImageURL)!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.bossListAddButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                }
                return
            }
            DispatchQueue.main.async {
                self.bossListAddButton.setImage(image, for: .normal)
            }
        }
        task.resume()
    }
    
    @objc func tapped() {
        let alert = UIAlertController(
            title: "난이도를 선택해 주세요.",
            message: "\n\n\n\n",
            preferredStyle: .alert
        )
        alert.view.addSubview(worldPickerView)
        
        alert.addTextField { textField in
            textField.placeholder = "파티원 수를 입력해주세요.(1인 ~ 6인)"
        }
        
        let ok = UIAlertAction(
            title: "OK",
            style: .default
        ) { (ok) in
            CoreDatamanager.shared.createBoss(
                name: self.bossList?.name ?? "",
                thumnailImageURL: self.bossList?.thumnailImageURL ?? "",
                difficulty: self.choiceBossDifficulty,
                price: self.choiceBossPrice,
                character: self.characterInfo ?? CharacterInfo()
            )
        }
        let cancel = UIAlertAction(
            title: "cancel",
            style: .cancel
        ) { (cancel) in
            
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        viewController?.present(alert, animated: true, completion: nil)
    }
        
}

extension WeeklyBossAddViewCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bossDifficultyList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bossDifficultyList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choiceBossDifficulty = bossDifficultyList[row]
        choiceBossPrice = bossPriceList[row]
    }
    
}

private extension WeeklyBossAddViewCell {
    
    func setupView() {
        self.contentView.backgroundColor = .white
        
        [bossListAddButton, checkmarkImageView].forEach { view in
            self.contentView.addSubview(view)
        }
    }
    
    func setupLayout() {
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        
        bossListAddButton.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.contentView)
            
            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.9).priority(750)
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.top.trailing.equalTo(self.contentView).inset(10)
        }
    }
    
    func setupPickerView() {
        worldPickerView.delegate = self
        worldPickerView.dataSource = self
        worldPickerView.selectRow(
            0,
            inComponent: 0,
            animated: true
        )
    }
    
}

extension String {
    
    var insertComma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        return numberFormatter.string(for: Double(self)) ?? self
    }
        
    var rebootPrice: String {
        let price = (Int(self) ?? 0) * 5
        
        return price.description
    }
    
}
