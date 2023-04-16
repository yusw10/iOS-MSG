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
    let options: [OptionDTO]

    enum CodingKeys: String, CodingKey {
        case equipmentSetOptionSet = "set"
        case options
    }
    
    func toDomain() -> EquipmentSetOption {
        return EquipmentSetOption(
            equipmentSetOptionSet: self.equipmentSetOptionSet,
            options: self.options.map({ optionDTO in
                return Option(
                    setCount: optionDTO.setCount,
                    optionName: optionDTO.optionName,
                    optionAmount: optionDTO.optionAmount
                )
            }))
    }
}

struct OptionDTO: Codable {
    let setCount, optionName, optionAmount: String

    enum CodingKeys: String, CodingKey {
        case setCount = "set_count"
        case optionName = "option_name"
        case optionAmount = "option_amount"
    }
}

//MARK: - Model

struct EquipmentSetOption {
    let equipmentSetOptionSet: String
    let options: [Option]
    
    func generateOptionList(at: Int) -> [Option] {
        var optionList: [Option] = []
        options.forEach { option in
            if option.setCount == "\(at)" {
                optionList.append(option)
            }
        }
        return optionList
    }
}

struct Option {
    let setCount: String
    let optionName: String
    let optionAmount: String
}
