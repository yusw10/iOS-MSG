//
//  JSONManager.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/02/02.
//

import Foundation

class JSONManager {
    static let shared = JSONManager()
    private let decoder = JSONDecoder()
    
    private init() { }
    
    func decodeToInfoList<T: Decodable>(from data: Data) -> [T]? {
        do {
            let returnData = try self.decoder.decode([T].self, from: data)
            return returnData
        } catch {
            print(error)
            return nil
        }
    }
}
