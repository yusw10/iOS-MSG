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
    
    // 캐릭터 정보 가져옴
    // MARK: CoreData 수정
    func readCharter() -> [MyCharacter] {
        let readRequest: NSFetchRequest<CharacterInfo> = CharacterInfo.fetchRequest()
                
        do {
            let dataToPerson = try context.fetch(readRequest)
            
            return dataToPerson.compactMap { charterInfo in
                MyCharacter.init(
                    name: charterInfo.name ?? "",
                    totalRevenue: charterInfo.totalRevenue ?? "",
                    uuid: charterInfo.uuid ?? "",
                    world: charterInfo.world ?? "",
                    bossInformations: readBossList(characterInfo: charterInfo).map({ bossInfomation in
                        MyWeeklyBoss(
                            checkClear: bossInfomation.checkClear,
                            crystalStonePrice: bossInfomation.crystalStonePrice ?? "",
                            difficulty: bossInfomation.difficulty ?? "",
                            name: bossInfomation.name ?? "",
                            thumnailImageURL: bossInfomation.thumnailImageURL ?? "",
                            member: bossInfomation.member ?? ""
                        )
                    })
                )
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // 보스 정보 가져옴
    func readBossList(characterInfo: CharacterInfo) -> [BossInformation] {
        let readRequest: NSFetchRequest<BossInformation> = BossInformation.fetchRequest()
         readRequest.predicate = NSPredicate(format: "charcterInfo = %@", characterInfo)
        do {
            let bossList = try context.fetch(readRequest)
            return bossList
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // 캐릭터 생성
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
    
    // 보스 생성
    func createBoss(name: String, thumnailImageURL: String, difficulty: String, member: String, price: String, character: CharacterInfo) {
        let bossInfo = BossInformation(context: context)
        bossInfo.name = name
        bossInfo.thumnailImageURL = thumnailImageURL
        bossInfo.checkClear = false
        
        character.addToBossInformations(bossInfo)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 보스 클리어 업데이트 기능 -> 불필요할수도?
    func updateBossClear(_ contact: BossInformation, clear: Bool) {
        contact.checkClear = clear
        saveContext()
    }
    
    // 캐릭터 삭제 기능 -> 불필요할수도?
    func deleteCharacter(_ character: CharacterInfo) {
        context.delete(character)
        saveContext()
    }
    
    // 보스 삭제 기능 -> 불필요할수도?
    func deleteBoss(_ boss: BossInformation) {
        context.delete(boss)
        saveContext()
    }
    
}
