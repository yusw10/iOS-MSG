//
//  File.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/02/02.
//

import Foundation

// MARK: Repository
// 추상 Repository를 만들고 여기서 Entity를 가져와 Model로 Mapping
// DTO를 저장하는 저장소는 필요가 없어 보여 생략
protocol JobInfoRepository {
    func fetchData(query: Query) async throws -> [JobInfo]
}

class APIJobInfoRepository: JobInfoRepository {
    private let urlSessionManager = URLSessionManager.shared
    private let jsonManager = JSONManager.shared
    
    func fetchData(query: Query) async throws -> [JobInfo] {
        let endpoint = EndPoint(query: query)
        let data = try await self.urlSessionManager.fetchData(endpoint: endpoint)
        guard let responseDTO: [JobInfoDTO] = self.jsonManager.decodeToInfoList(from: data) else {
            throw FetchError.failureParse
        }
        
        return responseDTO.map { $0.toDomain() }
    }
}

class AssetJobInfoRepository: JobInfoRepository {
    private let jsonManager = JSONManager.shared
    
    func fetchData(query: Query) async throws -> [JobInfo] {
        guard let fileLocation = Bundle.main.url(forResource: query.value, withExtension: "json") else {
            throw FetchError.failureLoadLocation
        }
        let data = try Data(contentsOf: fileLocation)
        guard let responseDTO: [JobInfoDTO] = self.jsonManager.decodeToInfoList(from: data) else {
            throw FetchError.failureParse
        }
        
        return responseDTO.map { $0.toDomain() }
    }
}

// MARK: UseCase
// 변하지 않는 비즈니스 로직에 대해서만 UseCase로 정의
// Model을 변화시켜 처리해야 하는 로직 같은 경우 UseCase에서 처리하면 각각의 UseCase가 Model을 가지고 있어야 하고 많은 UseCase를 생성해야 한다.
// Model을 싱글톤 패턴으로 만들면 가능하긴 함 (모든 UseCase가 같은 Model을 가지고 있다고 보장한다.)
class CommonJobInfoUseCase {
    private let repository: JobInfoRepository
    
    init(
        repository: JobInfoRepository
    ) {
        self.repository = repository
    }
    
    func excute(query: Query) async throws -> [JobInfo] {
        return try await self.repository.fetchData(query: query)
    } // 일종의 규칙 JobViewModel의 Model 은 반드시 해당 기능을 통해 [JobInfo] 타입으로 가져와야 한다.
}

class JobInfoViewModel {
    private let useCase: CommonJobInfoUseCase
    let jobListInfo: Observable<[JobInfo]> = Observable([]) // 전체 직업
    let jobInfo: Observable<JobInfo?> = Observable(nil) // 선택 된 직업
    
    private init(
        useCase: CommonJobInfoUseCase
    ) {
        self.useCase = useCase
    }
    
    convenience init(
        repository: JobInfoRepository
    ) {
        let useCase = CommonJobInfoUseCase(repository: repository)
        self.init(useCase: useCase)
    }
}


// MARK: Use Main View & Job List View
extension JobInfoViewModel {
    func trigger(query: Query) async {
        do {
            let data = try await self.useCase.excute(query: query)
            self.jobListInfo.value = data
        } catch {
            // 에러 처리
        }
    }
    
    func selectJob(_ index: Int) {
        jobInfo.value = self.jobListInfo.value[index]
    }
    
    func fetchJobInfo() -> [JobInfo] {
        return self.jobListInfo.value
    }
    
    func searchJobOrClass(_ text: String) -> [JobInfo] {
        return self.jobListInfo.value.filter { jobinfo in
            return jobinfo.name.contains(text) || jobinfo.type.contains(text)
        }
    }
}

// MARK: Use Detail Job View & Skill View
extension JobInfoViewModel {
    func selectLinkSkill() -> [Skill]? {
        return self.jobInfo.value?.linkSkill
    }
    
    func selectMetrixSkill(_ index: Int) -> Skill? {
        return self.jobInfo.value?.matrixSkillCore[index]
    }
    
    func selectReinforceSkill(_ index: Int) -> ReinforceSkillCore? {
        return self.jobInfo.value?.reinforceSkillCore[index]
    }
}
