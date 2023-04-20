//
//  EquipmentPart.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/04/01.
//

enum EquipmentPart: String, Codable {
    case weapon
    case subWeapon
    case head
    case top
    case suit
    case pants
    case shoulder
    case shoes
    case cloak
    case emblem
    case title // 칭호
    case badge
    case glove
    case eyeMask
    case faceMask
    case earring
    case necklace1
    case necklace2
    case ring1
    case ring2
    case ring3
    case ring4
    case pocket
    case heart
    case belt
    case android
    case empty
}

enum EquipmentSet: Codable {
    case arcane
    case absolabs
    case chaosRutabyss
    case basicBossAccessory
    case dawnBossAccessory
    case blackBossAccessory
    case defaultCase
}

enum SetOptions: Codable, CaseIterable {
    case atkAndMtk //공격력 및 마력
    case bossAtkDamage //보스 몬스터 공격시 데미지ㅌ
    case allStat //올스탯
    case maxHp //최대 HP
    case maxMp //최대 MP
    case maxHpRate //최대 HP%
    case maxMpRate //최대 MP%
    case defenseIgnore //몬스터 방어율 무시
    case defense //방어력
    case criticalHitRate //크리티컬 데미지
    case defaultCase
    
    func toString() -> String {
        switch self {
        case .atkAndMtk:
            return "공격력 및 마력"
        case .bossAtkDamage:
            return "보스 몬스터 공격시 데미지"
        case .allStat:
            return "올스탯"
        case .maxHp:
            return "최대 HP"
        case .maxMp:
            return "최대 MP"
        case .maxHpRate:
            return "최대 HP%"
        case .maxMpRate:
            return "최대 MP%"
        case .defenseIgnore:
            return "몬스터 방어율 무시"
        case .defense:
            return "방어력"
        case .criticalHitRate:
            return "크리티컬 데미지"
        case .defaultCase:
            return ""
        }
    }
}

let SlotPartsData: [[EquipmentPart]] = [
    [.ring1, .empty, .head, .empty, .emblem],
    [.ring2, .necklace1, .eyeMask, .empty, .title],
    [.ring3, .necklace2, .faceMask, .earring, .badge],
    [.ring4, .weapon, .top, .shoulder, .subWeapon],
    [.pocket, .belt, .pants, .glove, .cloak],
    [.empty, .empty, .shoes, .android, .heart]
]

extension String {
    func toPart() -> EquipmentPart {
        switch self {
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
        case "necklace1":
            return .necklace1
        case "necklace2":
            return .necklace2
        case "ring1":
            return .ring1
        case "ring2":
            return .ring2
        case "ring3":
            return .ring3
        case "ring4":
            return .ring4
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
    
    func toSet() -> EquipmentSet {
        switch self {
        case "arcane":
            return .arcane
        case "absolabs":
            return .absolabs
        case "chaosRutabyss":
            return .chaosRutabyss
        case "basicBossAccessory":
            return .basicBossAccessory
        case "dawnBossAccessory":
            return .dawnBossAccessory
        case "blackBossAccessory":
            return .blackBossAccessory
        default:
            return .defaultCase
        }
    }
    
    func toOptions() -> SetOptions {
        switch self {
        case "atkAndMtk": //공격력 및 마력
            return .atkAndMtk
        case "bossAtkDamage": //보스 몬스터 공격시 데미지ㅌ
            return .bossAtkDamage
        case "allStat": //올스탯
            return .allStat
        case "maxHp": //최대 HP
            return .maxHp
        case "maxMp": //최대 MP
            return .maxMp
        case "maxHpRate": //최대 HP%
            return .maxHpRate
        case "maxMpRate": //최대 MP%
            return .maxMpRate
        case "defenseIgnore": //몬스터 방어율 무시
            return .defenseIgnore
        case "defense": //방어력
            return .defense
        case "criticalHitRate": //크리티컬 데미지
            return .criticalHitRate
        default:
            return .defaultCase
        }
    }
}
