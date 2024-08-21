//
//  BBATMResponse.swift
//  bbatm
//
//  Created by Полина Лущевская on 16.05.24.
//

import Foundation
import CoreLocation

enum Card: String, Identifiable {
    var id: Self {
        return self
    }
    
    case belcart = "БЕЛКАРТ"
    case visa = "Visa"
    case masterCard = "MasterCard"
    case mir = "mir"
    
    var imageName: String {
        return switch self {
            case .belcart:
                "Belcart"
            case .visa:
                "Visa"
            case .masterCard:
                "MasterCard"
            case .mir:
                "Mir"
        }
    }
}

struct BBATMResponse: Decodable {
    let id: String // json: atmId
    let baseCurrency: String
    fileprivate let currencyRaw: String // json: currency
    
    var currencies: [String] {
        return self.currencyRaw.split(separator: " ").map({ String($0) })
    }
    
    fileprivate let cardsRaw: [String] // json: cards
    
    var cards: [Card] {
        return self.cardsRaw.compactMap({ Card(rawValue: $0) })
    }
    
    fileprivate let currentStatusRaw: String // json: currentStatus
    
    var currentStatus: Bool {
        return self.currentStatusRaw.lowercased() == "on"
    }
    
    let address: BBATMAddressResponse // json: Address
    let availability: BBMATMAvailabilityResponse // json: Availability
    
    var atm: ATM {
        return ATM(
            id: self.id,
            baseCurrency: self.baseCurrency,
            currencies: self.currencies,
            cards: self.cards,
            currentStatus: self.currentStatus,
            address: self.address.address,
            access24Hours: self.availability.access24Hours
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "atmId"
        case baseCurrency
        case currencyRaw = "currency"
        case cardsRaw = "cards"
        case currentStatusRaw = "currentStatus"
        case address = "Address"
        case availability = "Availability"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
     
        self.id = try container.decode(String.self, forKey: .id)
        self.baseCurrency = try container.decode(String.self, forKey: .baseCurrency)
        self.currencyRaw = try container.decode(String.self, forKey: .currencyRaw)
        self.cardsRaw = try container.decode([String].self, forKey: .cardsRaw)
        self.currentStatusRaw = try container.decode(String.self, forKey: .currentStatusRaw)
        self.address = try container.decode(BBATMAddressResponse.self, forKey: .address)
        self.availability = try container.decode(BBMATMAvailabilityResponse.self, forKey: .availability)
    }
}

struct BBATMAddressResponse: Decodable {
    let streetName: String
    let buildingNumber: String
    let townName: String
    let geolocation: BBATMAddressGeolocationResponse
    
    var address: ATM.Address {
        return ATM.Address(
            streetName: self.streetName,
            buildingNumber: self.buildingNumber,
            townName: self.townName,
            coordinates: self.geolocation.geographicCoordinates.coordinates
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case streetName
        case buildingNumber
        case townName
        case geolocation = "Geolocation"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
     
        self.streetName = try container.decode(String.self, forKey: .streetName)
        self.buildingNumber = try container.decode(String.self, forKey: .buildingNumber)
        self.townName = try container.decode(String.self, forKey: .townName)
        self.geolocation = try container.decode(BBATMAddressGeolocationResponse.self, forKey: .geolocation)
    }
}

struct BBATMAddressGeolocationResponse: Decodable {
    let geographicCoordinates: BBATMAddressGeolocationGeographicCoordinatesResponse
    
    enum CodingKeys: String, CodingKey {
        case geographicCoordinates = "GeographicCoordinates"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
     
        self.geographicCoordinates = try container.decode(BBATMAddressGeolocationGeographicCoordinatesResponse.self, forKey: .geographicCoordinates)
    }
}

struct BBATMAddressGeolocationGeographicCoordinatesResponse: Decodable {
    fileprivate let latitudeRaw: String
    
    var latitude: Double? {
        return Double(self.latitudeRaw)
    }
    
    fileprivate let longitudeRaw: String
    
    var longitude: Double? {
        return Double(self.longitudeRaw)
    }
    
    var coordinates: CLLocationCoordinate2D? {
        guard let latitude,
              let longitude
        else { return nil }
        
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case latitudeRaw = "latitude"
        case longitudeRaw = "longitude"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
     
        self.latitudeRaw = try container.decode(String.self, forKey: .latitudeRaw)
        self.longitudeRaw = try container.decode(String.self, forKey: .longitudeRaw)
    }
}

struct BBMATMAvailabilityResponse: Decodable {
    let access24Hours: Bool
    
    enum CodingKeys: CodingKey {
        case access24Hours
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
     
        self.access24Hours = try container.decode(Bool.self, forKey: .access24Hours)
    }
}
