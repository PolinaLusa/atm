//
//  ATM.swift
//  bbatm
//
//  Created by Полина Лущевская on 16.05.24.
//

import Foundation
import CoreLocation
import SwiftData

struct ATM: Identifiable, Equatable {
    struct Address {
        let streetName: String
        let buildingNumber: String
        let townName: String
        let coordinates: CLLocationCoordinate2D?
        
        var toSwiftData: LocalATM.LocalAddress {
            return LocalATM.LocalAddress(
                streetName: self.streetName, 
                buildingNumber: self.buildingNumber,
                townName: self.townName,
                longitude: self.coordinates?.longitude,
                latitude: self.coordinates?.latitude
            )
        }
    }
    
    let id: String
    let baseCurrency: String
    let currencies: [String]
    let cards: [Card]
    let currentStatus: Bool?
    let address: Address
    let access24Hours: Bool
    
    static func ==(lhs: ATM, rhs: ATM) -> Bool {
        return lhs.id == rhs.id
    }
    
    var toSwiftData: LocalATM {
        return LocalATM(
            id: self.id,
            baseCurrency: self.baseCurrency,
            currencies: self.currencies,
            cards: self.cards.map({ $0.rawValue }),
            currentStatus: self.currentStatus,
            address: self.address.toSwiftData,
            access24Hours: self.access24Hours)
    }
}
