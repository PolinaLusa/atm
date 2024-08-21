//
//  BBATMRootResponse.swift
//  bbatm
//
//  Created by Полина Лущевская on 16.05.24.
//

import Foundation

struct BBATMRootResponse: Decodable {
    let parsedData: BBATMDataResponse
    
    enum CodingKeys: String, CodingKey {
        case parsedData = "Data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.parsedData = try container.decode(BBATMDataResponse.self, forKey: .parsedData)
    }
}
