//
//  JobGroupDTO.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/02/19.
//

import Foundation

// MARK: JobGroupDTO
struct JobGroupDTO: Decodable {
    let type: String
    let jobs: [JobDTO]
    
    func toDomain() -> JobGroup {
        return JobGroup(
            type: self.type,
            jobs: self.jobs.map{ info in
                Job(
                    name: info.name,
                    jobClass: info.jobClass,
                    imageURL: info.imageURL,
                    unionEffect: UnionEffect(name: info.unionEffect),
                    linkSkill: Skill(name: info.linkSkill.name, description: info.linkSkill.description, imageURL: info.linkSkill.imageURL),
                    reinforceSkillCore: info.reinforceSkillCore.map{ skillInfo in
                        return ReinforceSkillCore(name: skillInfo.name, description20: skillInfo.description20, description40: skillInfo.description40, imageURL: skillInfo.imageURL)
                    },
                    matrixSkillCore: info.matrixSkillCore.map{ skillInfo in
                        return Skill(name: skillInfo.name, description: skillInfo.description, imageURL: skillInfo.imageURL)
                    }
                )
            }
        )
    }
}

// MARK: - JobDTO
struct JobDTO: Decodable {
    let name, jobClass: String
    let imageURL: String
    let unionEffect: String
    let linkSkill: SkillDTO
    let reinforceSkillCore: [ReinforceSkillCoreDTO]
    let matrixSkillCore: [SkillDTO]
    
    enum CodingKeys: String, CodingKey {
        case name
        case jobClass = "class"
        case imageURL = "image_url"
        case unionEffect = "union_effect"
        case linkSkill = "link_skill"
        case reinforceSkillCore = "reinforce_skill_core"
        case matrixSkillCore = "matrix_skill_core"
    }
}

// MARK: - LinkSkillDTO
struct SkillDTO: Decodable {
    let name, description: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case name, description
        case imageURL = "image_url"
    }
    
    func toDomain() -> Skill {
        return Skill(
            name: self.name,
            description: self.description,
            imageURL: self.imageURL
        )
    }
}

// MARK: - ReinforceSkillCoreDTO
struct ReinforceSkillCoreDTO: Decodable {
    let name: String
    let description20: String
    let description40: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case name
        case description20 = "description_20"
        case description40 = "description_40"
        case imageURL = "image_url"
    }
    
    func toDomain() -> ReinforceSkillCore {
        return ReinforceSkillCore(
            name: self.name,
            description20: self.description20,
            description40: self.description40,
            imageURL: self.imageURL
        )
    }
}


// MARK: Model
struct JobGroup: Hashable {
    let type: String
    let jobs: [Job]
    
    func hasText(_ text: String) -> Bool {
        return self.type.lowercased().contains(text)
    }
}

struct Job: Hashable {
    let name: String
    let jobClass: String
    let imageURL: String
    let unionEffect: UnionEffect
    let linkSkill: Skill
    let reinforceSkillCore: [ReinforceSkillCore]
    let matrixSkillCore: [Skill]
    
    func hasText(_ text: String) -> Bool {
        return self.name.lowercased().contains(text) || self.jobClass.lowercased().contains(text)
    }
}

struct UnionEffect: Hashable {
    let name: String
}

struct Skill: Hashable {
    let name: String
    let description: String
    let imageURL: String
}

struct ReinforceSkillCore: Hashable {
    let name: String
    let description20: String
    let description40: String
    let imageURL: String
}
