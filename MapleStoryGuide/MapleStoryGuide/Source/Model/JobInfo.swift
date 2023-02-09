//
//  JobInfo.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/02/08.
//

// MARK: Model
struct JobInfo {
    let name, type, jobClass, imageQuery: String
    let unionEffect: String
    let keyword: [Keyword]
    let linkSkill: [Skill]
    let reinforceSkillCore: [ReinforceSkillCore]
    let matrixSkillCore: [Skill]
}

// MARK: - Keyword
struct Keyword {
    let name: String
}

// MARK: - Skill
struct Skill {
    let name, description, imageQuery: String
}

// MARK: - ReinforceSkillCore
struct ReinforceSkillCore {
    let name: String
    let description20: String
    let description40: String
    let imageQuery: String
}
