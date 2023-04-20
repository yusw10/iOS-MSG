//
//  EquipmentSetOption.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/04/01.
//

import Foundation

// MARK: - DTO

struct EquipmentSetOptionDTO: Codable {
    let equipmentSetOptionSet: String
    let options: [SetOptionDTO]

    enum CodingKeys: String, CodingKey {
        case equipmentSetOptionSet = "set"
        case options
    }
    
    func toDomain() -> EquipmentSetOption {
        return EquipmentSetOption(
            equipmentSetOptionSet: self.equipmentSetOptionSet.toSet(),
            options: self.options.map({ SetOptionDTO in
                return SetOptionDTO.toDomain()
            })
        )
    }
}

struct SetOptionDTO: Codable {
    let setCount: String
    let option: [OptionDTO]

    enum CodingKeys: String, CodingKey {
        case setCount = "set_count"
        case option
    }
    
    func toDomain() -> SetOption {
        return SetOption(
            setCount: self.setCount,
            option: self.option.map({ OptionDTO in
                return Option(optionName: OptionDTO.optionName, optionAmount: OptionDTO.optionAmount)
            }))
    }
}

struct OptionDTO: Codable {
    let optionName: String
    let optionAmount: Int

    enum CodingKeys: String, CodingKey {
        case optionName = "option_name"
        case optionAmount = "option_amount"
    }
}

//MARK: - Model

struct EquipmentSetOption {
    let equipmentSetOptionSet: EquipmentSet
    let options: [SetOption]
}

struct SetOption {
    let setCount: String
    let option: [Option]
}

struct Option {
    let optionName: String
    let optionAmount: Int
    
    func toString() -> String {
        return "\(optionName) : \(optionName.contains("%") ? "\(optionAmount)%" : "\(optionAmount)")"
    }
}
