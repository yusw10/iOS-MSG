//
//  WeeklyBossCalculatorViewModel.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/27.
//

import CoreData

final class WeeklyBossCalculatorViewModel {
    
    private let coreDataManager = CoreDatamanager.shared

    var characterInfo: Observable<[CharacterInfo]> = Observable([])
        
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
    
    func deleteCharacter(id: CharacterInfo) {
        coreDataManager.deleteCharacter(id)
        fetchCharacterInfo()
    }
    
    func fetchBossList(character: CharacterInfo) -> [BossInformation] {
        let bossInformation = coreDataManager.readBossList(characterInfo: character)
        
        return bossInformation
    }
    
}
