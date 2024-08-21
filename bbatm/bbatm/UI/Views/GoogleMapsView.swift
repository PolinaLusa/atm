
//
//  GoogleMapsView.swift
//  bbatm
//
//  Created by Полина Лущевская on 16.05.24.
//

import SwiftUI
import GoogleMaps

struct GoogleMapsView: UIViewRepresentable {
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var atmsManager = ATMManager()
    
    @Binding var shouldCenterOnUserLocation: Bool
    @Binding var selectedATM: ATM?
    
    private let zoom: Float = 15.0
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(
            withLatitude: -33.86,
            longitude: 151.2,
            zoom: 6
        )
        
        let options = GMSMapViewOptions()
        options.camera = camera
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        if shouldCenterOnUserLocation {
            mapView.animate(
                toLocation: CLLocationCoordinate2D(
                    latitude: self.locationManager.latitude,
                    longitude: self.locationManager.longitude
                )
            )
            
            mapView.animate(toZoom: 15)
            
            DispatchQueue.main.async {
                shouldCenterOnUserLocation.toggle()
            }
        }
        
        self.addAtms(onMap: mapView)
    }
    
    func addAtms(onMap mapView: GMSMapView) {
        guard !self.atmsManager.atms.isEmpty else { return }
        
        self.atmsManager.atms.prefix(330).forEach { atm in
            guard let coordinates = atm.address.coordinates else { return }
            
            let marker = GMSMarker()
            marker.position = coordinates
            marker.map = mapView
            marker.icon = GMSMarker.markerImage(with: .systemGreen)
            marker.userData = atm
        }
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 53.893926, longitude: 27.546865)
        marker.map = mapView
        marker.icon = GMSMarker.markerImage(with: .systemBlue)
        marker.title = "БГУ"
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapsView
        
        init(parent: GoogleMapsView) {
            self.parent = parent
        }
        
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            guard let atm = marker.userData as? ATM else { return false }
            
            self.parent.selectedATM = atm
            return true
        }
    }
}

//struct GoogleMapsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoogleMapsView()
//    }
//}
