//
//  File.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/02/02.
//

import Foundation

// MARK: Repository
protocol EuipmentCalcRepository {
    func fetchEquipmentPartData(query: Query) async throws -> [EquipmentPartList]
    func fetchEquipmentSetData(query: Query) async throws -> [EquipmentSetOption]
}

class AssetEuipmentCalcRepository: EuipmentCalcRepository {
    private let jsonManager = JSONManager.shared
    
    func fetchEquipmentPartData(query: Query) async throws -> [EquipmentPartList] {
        guard let fileLocation = Bundle.main.url(forResource: query.value, withExtension: "json") else {
            throw FetchError.failureLoadLocation
        }
        let data = try Data(contentsOf: fileLocation)
        guard let responseDTO: [EquipmentPartListDTO] = self.jsonManager.decodeToInfoList(from: data) else {
            throw FetchError.failureParse
        }
        
        return responseDTO.map { $0.toDomain() }
    }
    
    func fetchEquipmentSetData(query: Query) async throws -> [EquipmentSetOption] {
        guard let fileLocation = Bundle.main.url(forResource: query.value, withExtension: "json") else {
            throw FetchError.failureLoadLocation
        }
        let data = try Data(contentsOf: fileLocation)
        guard let responseDTO: [EquipmentSetOptionDTO] = self.jsonManager.decodeToInfoList(from: data) else {
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
    
    func excutePart(query: Query) async throws -> [EquipmentPartList] {
        
        return try await self.repository.fetchEquipmentPartData(query: query)
    }
    
    func excuteSet(query: Query) async throws -> [EquipmentSetOption] {
        return try await self.repository.fetchEquipmentSetData(query: query)
    }
}

class EuipmentCalcViewModel {
    private let useCase: CommonEuipmentCalcUseCase
    let partList: Observable<[EquipmentPartList]> = Observable([]) // 전체 파츠별 장비 목록
    let setOptionList: Observable<[EquipmentSetOption]> = Observable([]) // 전체 세트별 옵션 리스트
    let equipedPartInfo: Observable<[EquipmentPart]> = Observable([]) // 현재 장착중인 파츠 리스트
    let currentlyApplidOptions: Observable<[EquipmentSetOption]> = Observable([])// 현재 적용중인 옵션 리스트
    let selectedPart: Observable<EquipmentPartList?> = Observable(nil) // 선택한 파츠 - 각 부위별 장비 목록 보여주고 파츠 및 세트 추가해야함
    
    private init(
        useCase: CommonEuipmentCalcUseCase
    ) {
        self.useCase = useCase
    }
    
    convenience init(
        repository: EuipmentCalcRepository
    ) {
        let useCase = CommonEuipmentCalcUseCase(repository: repository)
        self.init(useCase: useCase)
    }
}

// MARK: Use EquipmentCalcView
extension EuipmentCalcViewModel {
    
    // 장착 장비 관련(part) method
    func triggerPart(query: Query) async {
        do {
            let data = try await self.useCase.excutePart(query: query)
            self.partList.value = data
        } catch {
            debugPrint("EquipmentViewModel.swift - func triggerPart() error")
        }
    }
    
    func fetchEquipmentPartList() -> [EquipmentPartList] {
        return self.partList.value
    }
    
    func selectPart(at parts: EquipmentPart) -> [Part] {
        var currentPartList: [Part] = []
        
        for item in self.partList.value {
            if item.equipmentPart == parts {
                currentPartList = item.partList
                break
            }
        }
        return currentPartList
    }
    
    func addEquipedPart(at part: Part) {
        
    }
    
    // 옵션 관련(Set) method
    func triggerSet(query: Query) async {
        do {
            let data = try await self.useCase.excuteSet(query: query)
            self.setOptionList.value = data
        } catch {
            debugPrint("EquipmentViewModel.swift - func triggerSet() error")
        }
    }
    
    func fetchEquipmentSetOption() -> [EquipmentSetOption] {
        return self.currentlyApplidOptions.value
    }
    
    func generateSetOpion() -> [String: Int] {
        var optionTotal: [String: Int] = [:]
        currentlyApplidOptions.value.forEach { EquipmentSetOption in
            EquipmentSetOption.options.forEach { SetOption in
                SetOption.option.forEach { Option in
                    if optionTotal[Option.optionName] != nil {
                        optionTotal[Option.optionName] = Option.optionAmount
                    } else {
                        let amount = optionTotal[Option.optionName]
                        optionTotal[Option.optionName] = (amount ?? 0) + Option.optionAmount
                    }
                }
            }
        }
        
        return optionTotal
    }
    
}
/*
 1. 최초에
 EquipmentSetOptionDTO
 SetOptionDTO
 OptionDTO
 1.1 전체 세트옵션 갯수별 옵션 리스트 fetch > EquipmentSetDto.toDomain()
 1.2 각 파츠별 어떤 장비가 있는지 리스트 fetch > EquipmentPartDto.toDomain()
 2. 화면에 보여지는 리스트에 필요한것
 2.1 현재 장착중인 리스트
 
 눌럿을때 > 파츠 목록 불러오기 > 현재 선택된 파츠 목록
 
 
 
 
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
 */
