//
//  BossInformation+CoreDataProperties.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/28.
//
//

import Foundation
import CoreData


extension BossInformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BossInformation> {
        return NSFetchRequest<BossInformation>(entityName: "BossInformation")
    }

    @NSManaged public var checkClear: Bool
    @NSManaged public var crystalStonePrice: String?
    @NSManaged public var difficulty: String?
    @NSManaged public var name: String?
    @NSManaged public var thumnailImageURL: String?
    @NSManaged public var member: String?
    @NSManaged public var charcterInfo: CharacterInfo?

}

extension BossInformation : Identifiable {

}
