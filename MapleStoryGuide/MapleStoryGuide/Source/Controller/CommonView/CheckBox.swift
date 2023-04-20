//
//  CheckBox.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/04/20.
//

import UIKit

class CheckBox: UIButton {
    private let uncheckedImage = UIImage(systemName: "square")
    private let checkedImage = UIImage(systemName: "checkmark.square")
    private let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)

    private var isChecked: Bool = false {
        didSet {
            if isChecked == false {
                self.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
                self.setImage(uncheckedImage, for: .normal)
            } else {
                self.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
                self.setImage(checkedImage, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCheckState(state: Bool) {
        self.isChecked = state
    }
    
    func getCheckState() -> Bool {
        return isChecked
    }
}
