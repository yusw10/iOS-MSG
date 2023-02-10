//
//  APIRequest.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/02/01.
//

import Foundation

protocol APIRequest {
    var baseURL: String { get }
    var query: Query { get }
    var method: HTTPMethod { get }
}

extension APIRequest {
    var baseURL: String {
        return "http://drive.google.com/uc"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    func buildRequest() throws -> URLRequest {
        var components = URLComponents(string: self.baseURL)
        let queryItem = URLQueryItem(name: "id", value: query.value)
        components?.queryItems = [queryItem]
        
        guard let url = components?.url else {
            throw RequestError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        
        return request
    }
}
