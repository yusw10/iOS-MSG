//
//  WeeklyBossCalculatorViewModel.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/27.
//

import CoreData

// MARK: totalRevenue 같은 경우 사용하지 않습니다. CoreData Entity에서 제거해야 합니다.
struct MyCharacter: Hashable {
    let name: String
    let totalRevenue: String
    let uuid: String
    let world: String
    var bossInformations: [MyWeeklyBoss]
}

struct MyWeeklyBoss: Hashable {
    var checkClear: Bool
    let name: String
    let thumnailImageURL: String
}

final class WeeklyBossCharacterListViewModel {
    
    private let coreDataManager = CoreDatamanager.shared

    var characterInfo: Observable<[MyCharacter]> = Observable([])
    var selectedCharacter: Observable<MyCharacter?> = Observable(nil)

    func fetchCharacterInfo() {
        characterInfo.value = coreDataManager.readCharter()
    }
    
    func createCharacter(name: String, world: String) {
        let newData = MyCharacter(
            name: name,
            totalRevenue: "0",
            uuid: UUID().uuidString,
            world: world,
            bossInformations: []
        )
        
        characterInfo.value.append(newData)
        coreDataManager.createCharacter(from: newData)
    }
    
    func createBoss(from data: WeeklyBossInfo, _ index: Int) {
        let data = MyWeeklyBoss(
            checkClear: false,
            name: data.name,
            thumnailImageURL: data.imageURL
        )
        
        coreDataManager.createBoss(from: data, characterInfo.value[index].uuid)
        characterInfo.value[index].bossInformations.append(data)
        selectedCharacter.value?.bossInformations.append(data)
    }
 
    func deleteCharacter(index: Int) {
        coreDataManager.deleteCharacter(characterInfo.value[index].uuid)
        characterInfo.value.remove(at: index)
    }
    
    func deleteBoss(index: Int, _ characterIndex: Int) {
        guard let bossName = selectedCharacter.value?.bossInformations[index].name else {
            return
        }
        
        coreDataManager.deleteBoss(from: bossName)
        characterInfo.value[characterIndex].bossInformations.remove(at: index)
        selectedCharacter.value?.bossInformations.remove(at: index)
    }
    
    func updateBossClear(isClear: Bool, bossIndex: Int, characterIndex: Int) {
        characterInfo.value[characterIndex].bossInformations[bossIndex].checkClear = isClear
        selectedCharacter.value?.bossInformations[bossIndex].checkClear = isClear
        coreDataManager.updateBossClear(
            uuid: characterInfo.value[characterIndex].uuid,
            index: bossIndex,
            isClear
        )
    }
    
    func selectCharacter(index: Int) {
        selectedCharacter.value = characterInfo.value[index]
    }
    
    func fetchClearBossCount(index: Int) -> Int {
        var count = 0
        
        for bossInfo in characterInfo.value[index].bossInformations {
            if bossInfo.checkClear {
                count += 1
            } else {
                continue
            }
        }
        
        return count
    }
}
