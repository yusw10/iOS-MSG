//
//  BossInfo+CoreDataProperties.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/22.
//
//

import Foundation
import CoreData


extension BossInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BossInfo> {
        return NSFetchRequest<BossInfo>(entityName: "BossInfo")
    }

    @NSManaged public var checkClear: Bool
    @NSManaged public var crystalStonePrice: String?
    @NSManaged public var name: String?
    @NSManaged public var thumnailImageURL: String?
    @NSManaged public var difficulty: String?
    @NSManaged public var charcterInfo: CharacterInfo?

}

extension BossInfo : Identifiable {

}
