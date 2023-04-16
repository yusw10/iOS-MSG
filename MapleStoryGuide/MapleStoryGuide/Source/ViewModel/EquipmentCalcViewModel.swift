//
//  File.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/02/02.
//

import Foundation

// MARK: Repository
protocol EuipmentCalcRepository {
    func fetchData(query: Query) async throws -> [EquipmentPartList]
}

//class APIJobInfoRepository: JobInfoRepository {
//    private let urlSessionManager = URLSessionManager.shared
//    private let jsonManager = JSONManager.shared
//
//    func fetchData(query: Query) async throws -> [JobInfo] {
//        let endpoint = EndPoint(query: query)
//        let data = try await self.urlSessionManager.fetchData(endpoint: endpoint)
//        guard let responseDTO: [JobInfoDTO] = self.jsonManager.decodeToInfoList(from: data) else {
//            throw FetchError.failureParse
//        }
//
//        return responseDTO.map { $0.toDomain() }
//    }
//}

class AssetEuipmentCalcRepository: EuipmentCalcRepository {
    private let jsonManager = JSONManager.shared
    
    func fetchData(query: Query) async throws -> [EquipmentPartList] {
        guard let fileLocation = Bundle.main.url(forResource: query.value, withExtension: "json") else {
            throw FetchError.failureLoadLocation
        }
        let data = try Data(contentsOf: fileLocation)
        guard let responseDTO: [EquipmentPartListDTO] = self.jsonManager.decodeToInfoList(from: data) else {
            throw FetchError.failureParse
        }
        
        return responseDTO.map { $0.toDomain() }
    }
}

// MARK: UseCase
class CommonEuipmentCalcUseCase {
    private let repository: EuipmentCalcRepository
    
    init(
        repository: EuipmentCalcRepository
    ) {
        self.repository = repository
    }
    
    func excute(query: Query) async throws -> [EquipmentPartList] {
        return try await self.repository.fetchData(query: query)
    }
}

class EuipmentCalcModel {
    private let useCase: CommonEuipmentCalcUseCase
    let currentEquipedPartList: Observable<[EquipmentPartList]> = Observable([]) // 전체 부위별 장비 목록
    let jobInfo: Observable<Job?> = Observable(nil) // 선택 된 직업
    
    private init(
        useCase: CommonEuipmentCalcUseCase
    ) {
        self.useCase = useCase
    }
    
    convenience init(
        repository: CommonEuipmentCalcUseCase
    ) {
        let useCase = CommonEuipmentCalcUseCase(repository: repository)
        self.init(useCase: useCase)
    }
}

// MARK: Use Main View & Job List View
extension EuipmentCalcModel {
    func trigger(query: Query) async {
        do {
            let data = try await self.useCase.excute(query: query)
            //self.jobListInfo.value = data
        } catch {
            // 에러 처리
        }
    }
    
    // TODO: 로직 변경
    func selectJob(_ section: Int, _ index: Int) {
        jobInfo.value = self.jobListInfo.value[section].jobs[index]
    }
    
    func fetchJobGroup() -> [EquipmentPartList] {
        return self.currentEquipedPartList.value
    }
    
    func searchJob(_ text: String) async {
        var filterData = [JobGroup]()
        
        for groupInfo in jobListInfo.value {
            var jobs = [Job]()
            
            if groupInfo.hasText(text) {
                filterData.append(groupInfo)
                continue
            }
            
            for jobInfo in groupInfo.jobs {
                if jobInfo.hasText(text) {
                    jobs.append(jobInfo)
                }
            }
            
            if jobs.isEmpty {
                continue
            } else {
                let newJobGroup = JobGroup(type: groupInfo.type, jobs: jobs)
                filterData.append(newJobGroup)
            }
        }
        
        if filterData.isEmpty {
            await self.trigger(query: .newJson)
        } else {
            self.jobListInfo.value = filterData
        }
    }
}

/*
 
 1. 초기 세팅값
    1-1 . 각 세트의 몇 세트당 옵션들이 있는지 리스트
    1-2 . 각 부위별 어떤 파츠가 있는지
 2. 파츠 눌럿을 때 현재 선택된 장비 및 
 */
