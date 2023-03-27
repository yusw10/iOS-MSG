//
//  BossInfoViewModel.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/03/14.
//

import Foundation

protocol BossInfoRepository {
    func fetchData(query: Query) async throws -> [BossInfo]
}

class LocalBossInfoRepository: BossInfoRepository {
    private let jsonManager = JSONManager.shared
    
    func fetchData(query: Query) async throws -> [BossInfo] {
        guard let fileLocation = Bundle.main.url(forResource: query.value, withExtension: "json") else {
            throw FetchError.failureLoadLocation
        }
        
        let data = try Data(contentsOf: fileLocation)
        guard let responseDTO: [BossInfoDTO] = self.jsonManager.decodeToInfoList(from: data) else {
            throw FetchError.failureParse
        }
        
        return responseDTO.map { $0.toDomain() }
    }
}

class CommonBossInfoUseCase {
    private let repository: BossInfoRepository
    
    init(
        repository: BossInfoRepository
    ) {
        self.repository = repository
    }
    
    func excute(query: Query) async throws -> [BossInfo] {
        return try await self.repository.fetchData(query: query)
    }
}

class BossInfoViewModel {
    private let useCase: CommonBossInfoUseCase
    let bossListInfo: Observable<[BossInfo]> = Observable([])
    let bossInfo: Observable<BossInfo?> = Observable(nil)
    
    private init(
        useCase: CommonBossInfoUseCase
    ) {
        self.useCase = useCase
    }
    
    convenience init(
        repository: BossInfoRepository
    ) {
        let useCase = CommonBossInfoUseCase(repository: repository)
        self.init(useCase: useCase)
    }
}

extension BossInfoViewModel {
    @MainActor
    func trigger(query: Query) async {
        do {
            let data = try await self.useCase.excute(query: query)
            self.bossListInfo.value = data
        } catch {
            // 에러 처리
        }
    }
    /*
     This application is modifying the autolayout engine from a background thread after the engine was accessed from the main thread. This can lead to engine corruption and weird crashes.
     
     trigger method에 MainActor를 적용하면 해당 에러가 출력되지 않는다.
     */
    
    func selectBoss(_ index: Int) {
        bossInfo.value = self.bossListInfo.value[index]
    }
    
    func filterItem() -> [RewardItem] {
        var filteredItem = [RewardItem]()
        
        if let info = self.bossInfo.value {
            filteredItem = info.rewardItem.filter { item in
                return item.description != nil
            }
        }
        
        return filteredItem
    }
}
