//
//  LocalATM.swift
//  bbatm
//
//  Created by Полина Лущевская on 23.05.24.
//

import SwiftData
import CoreLocation

@Model final class LocalATM {
    @Model final class LocalAddress {
        var streetName: String
        var buildingNumber: String
        var townName: String
        var longitude: Double?
        var latitude: Double?
        
        @Attribute(.unique) var id: String = UUID().uuidString
        
        init(
            streetName: String,
            buildingNumber: String,
            townName: String,
            longitude: Double? = nil,
            latitude: Double? = nil
        ) {
            self.streetName = streetName
            self.buildingNumber = buildingNumber
            self.townName = townName
            self.longitude = longitude
            self.latitude = latitude
        }
        
        var toAddress: ATM.Address {
            let coordinates: CLLocationCoordinate2D? = if let longitude, let latitude {
                CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            } else {
                nil
            }
            
            return ATM.Address(
                streetName: self.streetName,
                buildingNumber: self.buildingNumber,
                townName: self.townName,
                coordinates: coordinates
            )
        }
    }
    
    @Attribute(.unique) var id: String
    var baseCurrency: String
    var currencies: [String]
    var cards: [String]
    var currentStatus: Bool?
    var address: LocalAddress
    var access24Hours: Bool
    
    init(
        id: String,
        baseCurrency: String,
        currencies: [String],
        cards: [String],
        currentStatus: Bool? = nil,
        address: LocalAddress,
        access24Hours: Bool
    ) {
        self.id = id
        self.baseCurrency = baseCurrency
        self.currencies = currencies
        self.cards = cards
        self.currentStatus = currentStatus
        self.address = address
        self.access24Hours = access24Hours
    }
    
    var toATM: ATM {
        return ATM(
            id: self.id,
            baseCurrency: self.baseCurrency,
            currencies: self.currencies,
            cards: self.cards.compactMap({ Card(rawValue: $0) }),
            currentStatus: self.currentStatus,
            address: self.address.toAddress,
            access24Hours: self.access24Hours
        )
    }
}
