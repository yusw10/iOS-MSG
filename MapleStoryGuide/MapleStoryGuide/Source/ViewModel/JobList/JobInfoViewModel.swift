//
//  File.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/02/02.
//

import Foundation

// MARK: Repository
protocol JobInfoRepository {
    func fetchData(query: Query) async throws -> [JobGroup]
}

class AssetJobInfoRepository: JobInfoRepository {
    private let jsonManager = JSONManager.shared
    
    func fetchData(query: Query) async throws -> [JobGroup] {
        guard let fileLocation = Bundle.main.url(forResource: query.value, withExtension: "json") else {
            throw FetchError.failureLoadLocation
        }
        let data = try Data(contentsOf: fileLocation)
        guard let responseDTO: [JobGroupDTO] = self.jsonManager.decodeToInfoList(from: data) else {
            throw FetchError.failureParse
        }
        
        return responseDTO.map { $0.toDomain() }
    }
}

// MARK: UseCase
class CommonJobInfoUseCase {
    private let repository: JobInfoRepository
    
    init(
        repository: JobInfoRepository
    ) {
        self.repository = repository
    }
    
    func excute(query: Query) async throws -> [JobGroup] {
        return try await self.repository.fetchData(query: query)
    }
}

class JobInfoViewModel {
    private let useCase: CommonJobInfoUseCase
    let jobListInfo: Observable<[JobGroup]> = Observable([]) // 전체 직업
    let jobInfo: Observable<Job?> = Observable(nil) // 선택 된 직업
    
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
    
    // TODO: 로직 변경
    func selectJob(_ section: Int, _ index: Int) {
        jobInfo.value = self.jobListInfo.value[section].jobs[index]
    }
    
    func fetchJobGroup() -> [JobGroup] {
        return self.jobListInfo.value
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
