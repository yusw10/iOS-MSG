//
//  EquipmentPart.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/04/01.
//

enum EquipmentPart: Codable {
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
    case necklace
    case ring
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
}

enum SetOptions: Codable {
    case atkAndMtk //공격력 및 마력
    case bossAtkDamage//보스 몬스터 공격시 데미지
    case allStat//올스탯
    case maxHp//최대 HP
    case maxMp//최대 MP
    case maxHpRate//최대 HP%
    case maxMpRate//최대 MP%
    case defenseIgnore//몬스터 방어율 무시
    case defense//방어력
    case criticalHitRate//크리티컬 데미지
}
