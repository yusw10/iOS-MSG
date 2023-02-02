//
//  JobInfo.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/02/02.
//

import Foundation

struct JobInfo: Decodable {
    let name, type, welcomeClass, imageQuery: String
    let unionEffect: String
    let keyword: [Keyword]
    let linkSkill: Skill
    let reinforceSkillCore: [ReinforceSkillCore]
    let matrixSkillCore: [Skill]

    enum CodingKeys: String, CodingKey {
        case name, type
        case welcomeClass = "class"
        case imageQuery = "image_query"
        case unionEffect = "union_effect"
        case keyword
        case linkSkill = "link_skill"
        case reinforceSkillCore = "reinforce_skill_core"
        case matrixSkillCore = "matrix_skill_core"
    }
}

// MARK: - Keyword
struct Keyword: Decodable {
    let name: String
}

// MARK: - Skill
struct Skill: Decodable {
    let name, description, imageQuery: String

    enum CodingKeys: String, CodingKey {
        case name, description
        case imageQuery = "image_query"
    }
}

// MARK: - ReinforceSkillCore
struct ReinforceSkillCore: Codable {
    let name: String
    let description20: String
    let description40: String
    let imageQuery: String

    enum CodingKeys: String, CodingKey {
        case name
        case description20 = "description_20"
        case description40 = "description_40"
        case imageQuery = "image_query"
    }
}
