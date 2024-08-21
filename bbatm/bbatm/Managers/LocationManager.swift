//
//  LocationManager.swift
//  bbatm
//
//  Created by Полина Лущевская on 16.05.24.
//

import Combine
import CoreLocation

final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation? {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    var latitude: CLLocationDegrees {
        return self.location?.coordinate.latitude ?? 0
    }
    
    var longitude: CLLocationDegrees {
        return self.location?.coordinate.longitude ?? 0
    }
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.location = location
    }
}
