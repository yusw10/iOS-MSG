//
//  URLSessionManager.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/02/01.
//

import Foundation

class URLSessionManager {
    private let endpoint: EndPoint
    private let urlSession = URLSession.shared
    
    init(
        endpoint: EndPoint
    ) {
        self.endpoint = endpoint
    }
    
    func fetchData() async throws -> Data {
        let (data, response) = try await urlSession.data(for: self.endpoint.buildRequest())
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw FetchError.badResponse
        }
        
        return data
    }
}
