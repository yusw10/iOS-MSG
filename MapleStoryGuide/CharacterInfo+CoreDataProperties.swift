//
//  CharacterInfo+CoreDataProperties.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/22.
//
//

import Foundation
import CoreData


extension CharacterInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterInfo> {
        return NSFetchRequest<CharacterInfo>(entityName: "CharacterInfo")
    }

    @NSManaged public var name: String?
    @NSManaged public var totalRevenue: String?
    @NSManaged public var uuid: String?
    @NSManaged public var world: String?
    @NSManaged public var bossInfos: NSSet?

}

// MARK: Generated accessors for bossInfos
extension CharacterInfo {

    @objc(addBossInfosObject:)
    @NSManaged public func addToBossInfos(_ value: BossInfo)

    @objc(removeBossInfosObject:)
    @NSManaged public func removeFromBossInfos(_ value: BossInfo)

    @objc(addBossInfos:)
    @NSManaged public func addToBossInfos(_ values: NSSet)

    @objc(removeBossInfos:)
    @NSManaged public func removeFromBossInfos(_ values: NSSet)

}

extension CharacterInfo : Identifiable {

}
