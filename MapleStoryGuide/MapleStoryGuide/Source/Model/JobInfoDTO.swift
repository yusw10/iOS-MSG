////
////  JobInfo.swift
////  MapleStoryGuide
////
////  Created by dhoney96 on 2023/02/02.
////
//
//struct JobInfoDTO: Decodable {
//    let name, type, jobClass: String
//    let unionEffect: String
//    let keyword: [KeywordDTO]
//    let linkSkill: SkillDTO
//    let reinforceSkillCore: [ReinforceSkillCoreDTO]
//    let matrixSkillCore: [SkillDTO]
//
//    enum CodingKeys: String, CodingKey {
//        case name, type
//        case jobClass = "class"
//        case unionEffect = "union_effect"
//        case keyword
//        case linkSkill = "link_skill"
//        case reinforceSkillCore = "reinforce_skill_core"
//        case matrixSkillCore = "matrix_skill_core"
//    }
//    
//    func toDomain() -> JobInfo {
//        return JobInfo(
//            name: self.name,
//            type: self.type,
//            jobClass: self.jobClass,
//            unionEffect: self.unionEffect,
//            keyword: self.keyword.map{ Keyword(name: $0.name) },
//            linkSkill: [Skill(
//                name: self.linkSkill.name,
//                description: self.linkSkill.description,
//                imageQuery: self.linkSkill.imageQuery
//            )],
//            reinforceSkillCore: self.reinforceSkillCore.map{
//                ReinforceSkillCore(
//                    name: $0.name,
//                    description20: $0.description20,
//                    description40: $0.description40,
//                    imageQuery: $0.imageQuery
//                )},
//            matrixSkillCore: self.matrixSkillCore.map{
//                Skill(
//                    name: $0.name,
//                    description: $0.description,
//                    imageQuery: $0.imageQuery
//                )}
//        )
//    }
//}
//
//// MARK: - Keyword
//struct KeywordDTO: Decodable {
//    let name: String
//}
//
//// MARK: - Skill
//struct SkillDTO: Decodable {
//    let name, description, imageQuery: String
//
//    enum CodingKeys: String, CodingKey {
//        case name, description
//        case imageQuery = "image_query"
//    }
//}
//
//// MARK: - ReinforceSkillCore
//struct ReinforceSkillCoreDTO: Codable {
//    let name: String
//    let description20: String
//    let description40: String
//    let imageQuery: String
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case description20 = "description_20"
//        case description40 = "description_40"
//        case imageQuery = "image_query"
//    }
//}
