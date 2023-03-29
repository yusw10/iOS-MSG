//
//  CharacterInfo+CoreDataProperties.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/28.
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
    @NSManaged public var bossInformations: NSSet?

}

// MARK: Generated accessors for bossInformations
extension CharacterInfo {

    @objc(addBossInformationsObject:)
    @NSManaged public func addToBossInformations(_ value: BossInformation)

    @objc(removeBossInformationsObject:)
    @NSManaged public func removeFromBossInformations(_ value: BossInformation)

    @objc(addBossInformations:)
    @NSManaged public func addToBossInformations(_ values: NSSet)

    @objc(removeBossInformations:)
    @NSManaged public func removeFromBossInformations(_ values: NSSet)

}

extension CharacterInfo : Identifiable {

}
