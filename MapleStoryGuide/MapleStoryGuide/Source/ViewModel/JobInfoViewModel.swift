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
protocol APIJobInfoRepository {
    func fetchData(query: Query) async throws -> [JobInfo]
}

class DefaultJobInfoRepository: APIJobInfoRepository {
    private let urlSessionManager = URLSessionManager.shared
    private let jsonManager = JSONManager.shared
    private var dataStroe = [String: Data]()
    
    func fetchData(query: Query) async throws -> [JobInfo] {
        let endpoint = EndPoint(query: query)
        
        if let storeData = dataStroe[query.value] {
            guard let responseDTO: [JobInfoDTO] = self.jsonManager.decodeToInfoList(from: storeData) else {
                throw FetchError.failureParse
            }
            
            return responseDTO.map { $0.toDomain() }
        } else {
            let data = try await self.urlSessionManager.fetchData(endpoint: endpoint)
            dataStroe.updateValue(data, forKey: query.value)
            
            guard let responseDTO: [JobInfoDTO] = self.jsonManager.decodeToInfoList(from: data) else {
                throw FetchError.failureParse
            }
            
            return responseDTO.map { $0.toDomain() }
        }
    }
}

// MARK: UseCase
// 변하지 않는 비즈니스 로직에 대해서만 UseCase로 정의
// Model을 변화시켜 처리해야 하는 로직 같은 경우 UseCase에서 처리하면 각각의 UseCase가 Model을 가지고 있어야 하고 많은 UseCase를 생성해야 한다.
// Model을 싱글톤 패턴으로 만들면 가능하긴 함 (모든 UseCase가 같은 Model을 가지고 있다고 보장한다.)
class CommonJobInfoUseCase {
    private let repository: APIJobInfoRepository
    
    init(
        repository: APIJobInfoRepository
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
        repository: APIJobInfoRepository
    ) {
        let useCase = CommonJobInfoUseCase(repository: repository)
        self.init(useCase: useCase)
    }
}


// MARK: Use Main View & Job List View
// 데이터(jobListInfo) 바인딩 하는 과정에서 그냥 데이터를 넣어줘도 상관없다고 생각합니다.(Section의 수와 각 Section의 Item 수를 결정하기 어려움)
// 함수 이용(fetchJobGroup)
extension JobInfoViewModel {
    // 최초 데이터를 가져올 때 사용
    func trigger(query: Query) async {
        do {
            let data = try await self.useCase.excute(query: query)
            self.jobListInfo.value = data
        } catch {
            // 에러 처리
        }
    }
    
    // 특정 직업을 골라서 DetailView로 넘어갈 때 사용
    func selectJob(_ index: Int) {
        jobInfo.value = self.jobListInfo.value[index]
    }
    
    // JobGroup이 필요하다면 사용 (문제점 : 하드코딩을 없애기 위해 딕셔너리 사용 과정에서 순서를 보장할 수 없습니다.)
    func fetchJobGroup() -> [JobGroup] {
        var jobList = [JobGroup]()
        var dict = [String: [Job]]()
        
        self.jobListInfo.value.forEach { info in
            let job = Job(title: info.name, jobImage: info.imageQuery)
            
            if var data = dict[info.type] {
                data.append(job)
                dict.updateValue(data, forKey: info.type)
            } else {
                dict.updateValue([job], forKey: info.type)
            }
        }
        
        for (key, value) in dict {
            let jobGroup = JobGroup(jobGroupTitle: key, jobs: value)
            jobList.append(jobGroup)
        }
        
        return jobList
    }
    
    // 검색할 때 사용
    // 만약 검색 결과가 없다면 다시 데이터를 불러옴 ( 아마 여기서 trigger 메서드는 api 통신 없이 데이터를 가져 올 겁니다. Repository에서 캐싱을 대충 구현 )
    func searchJobOrClass(_ text: String) async {
        let filterData = self.jobListInfo.value.filter { jobinfo in
            return jobinfo.name.contains(text) || jobinfo.type.contains(text)
        }
        
        if filterData.isEmpty {
            await self.trigger(query: .jsonQuery)
        } else {
            self.jobListInfo.value = filterData
        }
    }
}

// MARK: Use Detail Job View & Skill View
// 데이터(jobinfo) 바인딩 하는 과정에서 그냥 데이터를 넣어줘도 상관없다고 생각합니다. -> 아래 함수 사용할 필요 없을 수도 있음
// 바인딩에서 사용되는 value에서 각각 프로퍼티에 접근해 snapshot에 넣어 주면 됨
// 바인딩이 정상 적으로 동작하지 않는다면 해당 함수 사용 + Delegate 패턴 사용 ListViewController 에서 index를 전달 받아 대신 수행 하는 방식
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

struct JobGroup {
    let jobGroupTitle: String
    let jobs: [Job]
}

struct Job {
    let title: String
    let jobImage: String
}
