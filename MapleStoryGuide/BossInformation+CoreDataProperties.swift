//
//  BossInformation+CoreDataProperties.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/03/31.
//
//

import Foundation
import CoreData


extension BossInformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BossInformation> {
        return NSFetchRequest<BossInformation>(entityName: "BossInformation")
    }

    @NSManaged public var checkClear: Bool
    @NSManaged public var name: String?
    @NSManaged public var thumnailImageURL: String?
    @NSManaged public var charcterInfo: CharacterInfo?

}

extension BossInformation : Identifiable {

}
