//
//  BBATMDataResponse.swift
//  bbatm
//
//  Created by Полина Лущевская on 16.05.24.
//

import Foundation

struct BBATMDataResponse: Decodable {
    let atms: [BBATMResponse]
    
    enum CodingKeys: String, CodingKey {
        case atms = "ATM"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.atms = try container.decode([BBATMResponse].self, forKey: .atms)
    }
}
