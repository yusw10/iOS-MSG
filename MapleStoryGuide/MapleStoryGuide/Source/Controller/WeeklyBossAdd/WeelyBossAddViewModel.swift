//
//  WeelyBossAddViewModel.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/03/28.
//

import CoreData

protocol WeeklyBossInfoRepository {
    func fetchData(query: Query) async throws -> [WeeklyBossInfo]
}

class LocalWeeklyBossInfoRepository: WeeklyBossInfoRepository {
    private let jsonManager = JSONManager.shared
    
    func fetchData(query: Query) async throws -> [WeeklyBossInfo] {
        guard let fileLocation = Bundle.main.url(forResource: query.value, withExtension: "json") else {
            throw FetchError.failureLoadLocation
        }
        
        let data = try Data(contentsOf: fileLocation)
        guard let responseDTO: [WeeklyBossInfoDTO] = self.jsonManager.decodeToInfoList(from: data) else {
            throw FetchError.failureParse
        }
        
        return responseDTO.map { $0.toDomain() }
    }
}

class CommonWeeklyBossInfoUseCase {
    private let repository: WeeklyBossInfoRepository
    
    init(
        repository: WeeklyBossInfoRepository
    ) {
        self.repository = repository
    }
    
    func excute(query: Query) async throws -> [WeeklyBossInfo] {
        return try await self.repository.fetchData(query: query)
    }
}

final class WeelyBossAddViewModel {

    var bossList: Observable<[WeeklyBossInfo]> = Observable([])
    var characterInfo: MyCharacter?
    
    private let coreDataManager = CoreDatamanager.shared
    private let useCase: CommonWeeklyBossInfoUseCase

    private init(
        useCase: CommonWeeklyBossInfoUseCase,
        characterInfo: MyCharacter
    ) {
        self.useCase = useCase
        self.characterInfo = characterInfo
    }
    
    convenience init(
        repository: WeeklyBossInfoRepository,
        characterInfo: MyCharacter
    ) {
        let useCase = CommonWeeklyBossInfoUseCase(repository: repository)
        self.init(useCase: useCase, characterInfo: characterInfo)
    }
    
    @MainActor
    func trigger(query: Query) async {
        do {
            let data = try await self.useCase.excute(query: query)
            
            self.bossList.value = data
        } catch {
            // 에러 처리
        }
    }
    
}
