//
//  MockSection.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/02/01.
//

import Foundation
import UIKit

// MARK: - Section

enum Section: CaseIterable {
    case jobImage
    case linkSkill
    case reinforceSkillCore
    case matrixSkillCore
}

// MARK: - JobInfo

struct JobInfo: Equatable, Hashable {
    
    let name, type, welcomeClass, imageQuery: String
    let unionEffect: String
    let keyword: [Keyword]
    let linkSkill: [LinkSkill]
    let reinforceSkillCore: [ReinforceSkillCore]
    let matrixSkillCore: [MatrixSkillCore]

    enum CodingKeys: String, CodingKey {
        case name, type
        case welcomeClass = "class"
        case imageQuery = "image_query"
        case unionEffect = "union_effect"
        case keyword
        case linkSkil = "link_skil"
        case reinforceSkillCore = "reinforce_skill_core"
        case matrixSkillCore = "matrix_skill_core"
    }
    
    static func == (lhs: JobInfo, rhs: JobInfo) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
}

// MARK: - Keyword

struct Keyword: Codable {
    let name: String
}

// MARK: - LinkSkil

struct LinkSkill: Codable, Hashable {
    let name, description, imageQuery: String

    enum CodingKeys: String, CodingKey {
        case name, description
        case imageQuery = "image_query"
    }
}

// MARK: - MatrixSkillCore

struct MatrixSkillCore: Codable, Hashable {
    let name, description, imageQuery: String

    enum CodingKeys: String, CodingKey {
        case name, description
        case imageQuery = "image_query"
    }
}

// MARK: - ReinforceSkillCore

struct ReinforceSkillCore: Codable, Hashable {
    let name, description20, description40, imageQuery: String

    enum CodingKeys: String, CodingKey {
        case name
        case description20 = "description_20"
        case description40 = "description_40"
        case imageQuery = "image_query"
    }
}
