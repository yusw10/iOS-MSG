//
//  NumberFormatter.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/04/20.
//

import Foundation

class NumberFormatterManager {
    static let shared = NumberFormatterManager()
    private let formatter = NumberFormatter()
    
    private var stringFormatter: NumberFormatter {
        self.formatter.numberStyle = .decimal
        return formatter
    }
    
    private init() { }
    
    func format(from number: Int) -> String? {
        return stringFormatter.string(from: number as NSNumber)
    }
}
