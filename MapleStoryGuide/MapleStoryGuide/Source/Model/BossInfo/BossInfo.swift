//
//  BossInfo.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/03/13.
//

struct BossInfo: Hashable {
    let name: String
    let imageURL: String
    let level: [ModeLevel]
    let force: Force?
    let rewardPrice: [RewardPrice]
    let rewardItem: [RewardItem]
    
    init(name: String, imageURL: String, level: [ModeLevel], force: Force? = nil, rewardPrice: [RewardPrice], rewardItem: [RewardItem]) {
        self.name = name
        self.imageURL = imageURL
        self.level = level
        self.force = force
        self.rewardPrice = rewardPrice
        self.rewardItem = rewardItem
    }
}

struct ModeLevel: Hashable {
    let mode: String
    let level: Int
}

struct Force: Hashable {
    let type: String
    let modeForce: [ModeForce]
}

struct ModeForce: Hashable {
    let mode: String
    let force: Int
}

struct RewardPrice: Hashable {
    let mode: String
    let price: Int
}

struct RewardItem: Hashable {
    let name: String
    let imageURL: String
    let description: String?
}

// MARK: - BossInfoDTO
struct BossInfoDTO: Decodable {
    let name: String
    let imageURL: String
    let modeLevel: [ModeLevelDTO]
    let force: ForceDTO?
    let rewardPrice: [RewardPriceDTO]
    let rewardItem: [RewardItemDTO]

    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "image_url"
        case modeLevel = "mode_level"
        case rewardPrice = "reward_price"
        case rewardItem = "reward_item"
        case force
    }
    
    func toDomain() -> BossInfo {
        if let force = self.force {
            return BossInfo(
                name: self.name,
                imageURL: self.imageURL,
                level: self.modeLevel.map{ DTO in
                    ModeLevel(mode: DTO.mode, level: DTO.level)
                },
                force: Force(type: force.type, modeForce: force.modeForce.map { DTO in
                    return ModeForce(mode: DTO.mode, force: DTO.force)
                }),
                rewardPrice: self.rewardPrice.map { DTO in
                    return RewardPrice(mode: DTO.mode, price: DTO.price)
                },
                rewardItem: self.rewardItem.map { DTO in
                    return RewardItem(name: DTO.name, imageURL: DTO.imageURL, description: DTO.description)
                }
            )
        } else {
            return BossInfo(
                name: self.name,
                imageURL: self.imageURL,
                level: self.modeLevel.map{ DTO in
                    ModeLevel(mode: DTO.mode, level: DTO.level)
                },
                rewardPrice: self.rewardPrice.map { DTO in
                    return RewardPrice(mode: DTO.mode, price: DTO.price)
                },
                rewardItem: self.rewardItem.map { DTO in
                    return RewardItem(name: DTO.name, imageURL: DTO.imageURL, description: DTO.description)
                }
            )
        }
    }
}

// MARK: - ForceDTO
struct ForceDTO: Decodable {
    let type: String
    let modeForce: [ModeForceDTO]

    enum CodingKeys: String, CodingKey {
        case type
        case modeForce = "mode_force"
    }
}

// MARK: - ModeForceDTO
struct ModeForceDTO: Decodable {
    let mode: String
    let force: Int
}

// MARK: - ModeLevelDTO
struct ModeLevelDTO: Decodable {
    let mode: String
    let level: Int
}

// MARK: - RewardItemDTO
struct RewardItemDTO: Decodable {
    let name: String
    let imageURL: String
    let description: String?

    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "image_url"
        case description
    }
}

// MARK: - RewardPriceDTO
struct RewardPriceDTO: Decodable {
    let mode: String
    let price: Int
}
