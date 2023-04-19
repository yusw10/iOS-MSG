//
//  EquipmentPartDTO.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/04/01.
//
import Foundation

// MARK: - DTO

struct EquipmentPartListDTO: Codable {
    let equipmentPart: EquipmentPart
    let partList: [PartDTO]

    enum CodingKeys: String, CodingKey {
        case equipmentPart = "equipment_part"
        case partList = "part_list"
    }
    
    func toDomain() -> EquipmentPartList {
        return EquipmentPartList(
            equipmentPart: self.equipmentPart,
            partList: self.partList.map({ partDTO in
                Part(
                    name: partDTO.name,
                    partListSet: partDTO.partListSet ,
                    imageURL: partDTO.imageURL
                )
            }))
    }
}

struct PartDTO: Codable {
    let name: String
    let partListSet: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case name
        case partListSet = "set"
        case imageURL
    }
}

//MARK: - Model

struct EquipmentPartList { // 부위별 파츠 목록
    let equipmentPart: EquipmentPart
    let partList: [Part]

    enum CodingKeys: String, CodingKey {
        case equipmentPart = "equipment_part"
        case partList = "part_list"
    }
}

struct Part { // 장비
    let name: String
    let partListSet: EquipmentSet
    let imageURL: String
    
    init(name: String, partListSet: String, imageURL: String) {
        self.name = name
        self.partListSet = partListSet.toSet()
        self.imageURL = imageURL
    }
}

//MARK: - EuqipmentPartDTO Sample Data

extension EquipmentPartListDTO {
    static let sample = EquipmentPartList(equipmentPart: .head, partList: [
        Part(name: "아케인셰이드",
             partListSet: "head",
             imageURL: "https://drive.google.com/file/d/1V43YTjIjAe2bpzGKeCQhshUpguhSohlJ/view?usp=sharing"
        )
    ])
}
