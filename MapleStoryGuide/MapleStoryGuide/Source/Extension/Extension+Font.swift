//
//  Extension+Font.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/04/20.
//

import UIKit

extension UIFont {
    
    enum MapleFont: String {
        case bold = "Bold"
        case light = "Light"
    }
    
    static func MapleHeaderFont(size: CGFloat = 23, font: MapleFont = .bold) -> UIFont {
        return UIFont(name: "Maplestory OTF \(font.rawValue)", size: size)!
    }
    
    static func MapleTitleFont(size: CGFloat = 20, font: MapleFont = .bold) -> UIFont {
        return UIFont(name: "Maplestory OTF \(font.rawValue)", size: size)!
    }
    
    static func MapleLightFont(size: CGFloat = 16, font: MapleFont = .light) -> UIFont {
        return UIFont(name: "Maplestory OTF \(font.rawValue)", size: size)!
    }
    
    static func MapleLightDesciptionFont(size: CGFloat = 10, font: MapleFont = .light) -> UIFont {
        return UIFont(name: "Maplestory OTF \(font.rawValue)", size: size)!
    }
    
}
