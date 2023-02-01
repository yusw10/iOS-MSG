//
//  File.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/02/01.
//

class EndPoint: APIRequest {
    var query: Query
    
    init(
        query: Query
    ) {
        self.query = query
    }
}
