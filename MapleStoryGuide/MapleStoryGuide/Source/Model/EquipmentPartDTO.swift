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

struct EquipmentPartList {
    let equipmentPart: EquipmentPart
    let partList: [Part]

    enum CodingKeys: String, CodingKey {
        case equipmentPart = "equipment_part"
        case partList = "part_list"
    }
}

struct Part {
    let name: String
    let partListSet: EquipmentPart
    let imageURL: String
    
    init(name: String, partListSet: String, imageURL: String) {
        self.name = name
        self.partListSet = toPart(input: partListSet)
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

func toPart(input: String) -> EquipmentPart {
    switch input {
    case "weapon":
        return .weapon
    case "subWeapon":
        return .subWeapon
    case "head":
        return .head
    case "top":
        return .top
    case "suit":
        return .suit
    case "pants":
        return .pants
    case "shoulder":
        return .shoulder
    case "shoes":
        return .shoes
    case "cloak":
        return .cloak
    case "emblem":
        return .emblem
    case "title": // 칭호
        return .title
    case "badge":
        return .badge
    case "glove":
        return .glove
    case "eyeMask":
        return .eyeMask
    case "faceMask":
        return .faceMask
    case "earring":
        return .earring
    case "necklace":
        return .necklace
    case "ring":
        return .ring
    case "pocket":
        return .pocket
    case "heart":
        return .heart
    case "belt":
        return .belt
    case "android":
        return .android
    case "empty":
        return .empty
    default :
        return .empty
    }
}
