//
//  Components.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/02/01.
//

enum Query {
    case jsonQuery // 고정된 값 사용
    case imageQuery(query: String) // 상황에 따라 달라짐
    
    var value: String {
        switch self {
        case .jsonQuery:
            return "1231412312312312"
        case .imageQuery(query: let query):
            return query
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
}

enum RequestError: Error {
    case badURL
}
