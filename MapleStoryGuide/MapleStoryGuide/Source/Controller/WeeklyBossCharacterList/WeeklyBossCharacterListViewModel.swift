//
//  WeeklyBossCalculatorViewModel.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/27.
//

import CoreData

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
        characterInfo.value.append(
            MyCharacter(
                name: name,
                totalRevenue: "",
                uuid: UUID().uuidString,
                world: world,
                bossInformations: []
            )
        )
    }
 
    func deleteCharacter(index: Int) {
        characterInfo.value.remove(at: index)
    }
    
    func fetchBossList(character: CharacterInfo) -> [BossInformation] {
        let bossInformation = coreDataManager.readBossList(characterInfo: character)
        
        return bossInformation
    }
    
    func selectCharacter(index: Int) {
        selectedCharacter.value = characterInfo.value[index]
    }
    
}
