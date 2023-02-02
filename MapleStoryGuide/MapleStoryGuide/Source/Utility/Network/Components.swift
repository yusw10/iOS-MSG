//
//  Components.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/02/01.
//

enum Query {
    case jsonQuery
    case imageQuery(query: String)
    
    var value: String {
        switch self {
        case .jsonQuery:
            return "1-SR5SFykHmNGkkyysXow1Cty8ENJQ6SZ"
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

enum FetchError: Error {
    case badResponse
}
