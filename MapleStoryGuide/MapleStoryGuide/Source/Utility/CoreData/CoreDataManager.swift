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
                            name: bossInfomation.name ?? "",
                            thumnailImageURL: bossInfomation.thumnailImageURL ?? ""
                        )
                    })
                )
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func readBossList(characterInfo: CharacterInfo) -> [BossInformation] {
        let readRequest: NSFetchRequest<BossInformation> = BossInformation.fetchRequest()
         readRequest.predicate = NSPredicate(format: "charcterInfo = %@", characterInfo)
        do {
            let bossList = try context.fetch(readRequest)
            return bossList
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func createCharacter(from model: MyCharacter) {
        let character = CharacterInfo(context: context)
        
        character.uuid = model.uuid
        character.name = model.name
        character.world = model.world
        character.totalRevenue = model.totalRevenue
        
        saveContext()
    }
    
    func createBoss(from model: MyWeeklyBoss, _ id: String) {
        let bossInfo = BossInformation(context: context)
        bossInfo.name = model.name
        bossInfo.thumnailImageURL = model.thumnailImageURL
        bossInfo.checkClear = model.checkClear
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CharacterInfo")
        request.predicate = NSPredicate(format: "uuid = %@", id as CVarArg)
        
        do {
            let data = try context.fetch(request)
            guard let charaterInfo = data[0] as? CharacterInfo else { return }
            charaterInfo.addToBossInformations(bossInfo)
        } catch {
            // 에러 처리
        }
        
        saveContext()
    }
    
    func updateBossClear(uuid: String, index: Int, _ isClear: Bool) {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CharacterInfo")
        request.predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)
        
        do {
            let data = try context.fetch(request)
            guard let characterInfo = data[0] as? CharacterInfo else { return }
            let bossList = self.readBossList(characterInfo: characterInfo)
            bossList[index].checkClear = isClear
        } catch {
            // 에러 처리
        }
        saveContext()
    }
    
    func deleteCharacter(_ id: String) {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CharacterInfo")
        request.predicate = NSPredicate(format: "uuid = %@", id as CVarArg)
        
        do {
            let data = try context.fetch(request)
            guard let charaterInfo = data[0] as? NSManagedObject else { return }
            context.delete(charaterInfo)
        } catch {
            // 에러 처리
        }
        
        saveContext()
    }
    
    func deleteBoss(uuid: String, name: String) { // 이부분 수정 필요 특정 보스가 지워지지 않는다.
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CharacterInfo")
        request.predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)
        
        do {
            let data = try context.fetch(request)
            guard let characterInfo = data[0] as? CharacterInfo else { return }
            guard let bossList = characterInfo.bossInformations else { return }
            
            for boss in bossList {
                guard let bossInfo = boss as? BossInformation else { return }
                
                if bossInfo.name == name {
                    characterInfo.removeFromBossInformations(bossInfo)
                    break
                }
            }
        } catch {
            // 에러 처리
        }
        
        saveContext()
    }
    
    func resetWeeklyBossCoreData() {
        let characterRequest: NSFetchRequest<CharacterInfo> = CharacterInfo.fetchRequest()
        
        do {
            let characterList = try context.fetch(characterRequest)
            characterList.forEach { characterInfo in
                let bossList = readBossList(characterInfo: characterInfo)
                
                for boss in bossList {
                    if boss.name == "검은 마법사" {
                        continue
                    } else {
                        boss.checkClear = false
                    }
                }
            }
        } catch {
            
        }
        
        saveContext()
    }
    
    func resetMonthlyBossCoreData() {
        let characterRequest: NSFetchRequest<CharacterInfo> = CharacterInfo.fetchRequest()
        
        do {
            let characterList = try context.fetch(characterRequest)
            characterList.forEach { characterInfo in
                let bossList = readBossList(characterInfo: characterInfo)
                
                for boss in bossList {
                    if boss.name == "검은 마법사" {
                        boss.checkClear = false
                    } else {
                        continue
                    }
                }
            }
        } catch {
            
        }
        
        saveContext()
    }
}
