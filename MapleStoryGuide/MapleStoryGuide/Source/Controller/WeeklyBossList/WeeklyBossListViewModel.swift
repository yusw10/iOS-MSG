//
//  WeeklyBossListViewModel.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/27.
//

import CoreData

final class WeeklyBossListViewModel {
    
    private let coreDataManager = CoreDatamanager.shared
    
    var bossInformation: Observable<[BossInformation]> = Observable([])
    var characterInfo: CharacterInfo?
    
    init(characterInfo: CharacterInfo) {
        self.characterInfo =  characterInfo
    }
    
    func fetchBossInformation() {
        bossInformation.value = coreDataManager.readBossList(
            characterInfo: characterInfo ?? CharacterInfo()
        )
    }
    
    func updateBossClear(bossInformation: BossInformation, clear: Bool) {
        coreDataManager.updateBossClear(
            bossInformation,
            clear: clear
        )
        fetchBossInformation()
    }
    
    func deleteBossInformation(id: BossInformation) {
        CoreDatamanager.shared.deleteBoss(id)
        fetchBossInformation()
    }
    
}
