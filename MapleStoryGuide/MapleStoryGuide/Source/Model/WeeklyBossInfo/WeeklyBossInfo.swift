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
    
    init(name: String, imageURL: String) {
        self.name = name
        self.imageURL = imageURL
    }
}

// MARK: - BossInfoDTO
struct WeeklyBossInfoDTO: Decodable {
    let name: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "image_url"
    }
    
    func toDomain() -> WeeklyBossInfo {
        return WeeklyBossInfo(
            name: self.name,
            imageURL: self.imageURL
        )
    }
}
