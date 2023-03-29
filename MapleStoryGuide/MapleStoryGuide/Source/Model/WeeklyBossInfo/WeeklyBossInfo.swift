//
//  WeeklyBossInfo.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/29.
//

import Foundation

struct WeeklyBossInfo: Hashable {
    let name: String
    let imageURL: String
    let level: [ModeLevel]
    let rewardPrice: [RewardPrice]
    
    init(name: String, imageURL: String, level: [ModeLevel], rewardPrice: [RewardPrice]) {
        self.name = name
        self.imageURL = imageURL
        self.level = level
        self.rewardPrice = rewardPrice
    }
}

// MARK: - BossInfoDTO
struct WeeklyBossInfoDTO: Decodable {
    let name: String
    let imageURL: String
    let modeLevel: [ModeLevelDTO]
    let rewardPrice: [RewardPriceDTO]

    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "image_url"
        case modeLevel = "mode_level"
        case rewardPrice = "reward_price"
    }
    
    func toDomain() -> WeeklyBossInfo {
        return WeeklyBossInfo(
            name: self.name,
            imageURL: self.imageURL,
            level: self.modeLevel.map{ DTO in
                ModeLevel(mode: DTO.mode, level: DTO.level)
            },
            rewardPrice: self.rewardPrice.map { DTO in
                return RewardPrice(mode: DTO.mode, price: DTO.price)
            }
        )
    }
}
