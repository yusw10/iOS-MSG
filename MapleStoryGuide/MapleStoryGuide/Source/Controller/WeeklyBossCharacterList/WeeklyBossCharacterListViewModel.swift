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
    let checkClear: Bool
    let crystalStonePrice: String
    let difficulty: String
    let name: String
    let thumnailImageURL: String
    let member: String
}

final class WeeklyBossCharacterListViewModel {
    
    private let coreDataManager = CoreDatamanager.shared

    var characterInfo: Observable<[MyCharacter]> = Observable([])
    var selectedCharacter: Observable<MyCharacter?> = Observable(nil)

    func fetchCharacterInfo() {
        characterInfo.value = coreDataManager.readCharter()
    }
    
    func createCharacter(name: String, world: String) {
        coreDataManager.createCharacter(
            name: name,
            world: world
        )
        fetchCharacterInfo()
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
        
        print(selectedCharacter.value)
    }
    
}
