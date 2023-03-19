//
//  CoreDataManager.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/14.
//

import Foundation
import CoreData

class CoreDatamanager {
    
    static var shared = CoreDatamanager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func readCharter() -> [CharacterInfo] {
        let readRequest: NSFetchRequest<CharacterInfo> = CharacterInfo.fetchRequest()
                
        do {
            let dataToPerson = try context.fetch(readRequest)
            return dataToPerson
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func readBossList(characterInfo: CharacterInfo) -> [BossInfo] {
        let readRequest: NSFetchRequest<BossInfo> = BossInfo.fetchRequest()
         readRequest.predicate = NSPredicate(format: "charcterInfo = %@", characterInfo)
        do {
            let bossList = try context.fetch(readRequest)
            return bossList
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func createCharacter(name: String, world: String) {
        let character = CharacterInfo(context: context)
        
        character.uuid = UUID().uuidString
        character.name = name
        character.world = world
        character.totalRevenue = "0"
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createBoss(name: String, price: String, character: CharacterInfo) {
        let bossInfo = BossInfo(context: context)
        bossInfo.name = name
        bossInfo.crystalStonePrice = price
        bossInfo.checkClear = false
        
        character.addToBossInfos(bossInfo)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateBossClear(_ contact: BossInfo, clear: Bool) {
        contact.checkClear = clear
        saveContext()
    }
    
    func deleteCharacter(_ character: CharacterInfo) {
        context.delete(character)
        saveContext()
    }
    
}
