//
//  LocationManager.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 10/10/2021.
//

import CoreLocation
import Foundation
import SwiftUI
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // - Private
    private let manager: CLLocationManager = CLLocationManager()
    
    static var shared = LocationManager()
    
    // - Public
    @Published var lastLocation: CLLocation? = nil
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 250, longitudinalMeters: 250)
    
    private func validateLocation(status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .notDetermined, .restricted:
            manager.requestWhenInUseAuthorization()
            manager.requestLocation()
        @unknown default:
            fatalError()
        }
    }
    
    var isLocationAuthorized: Bool {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .denied, .notDetermined, .restricted:
            return false
        @unknown default:
            return false
        }
    }
    
    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.manager.activityType = .other
        
        print("DEBUG: Locationmanager init...")
    }
    
    func requestLocation(){
        self.manager.requestLocation()
    }
    
    func requestAuthorization(){
        self.manager.requestWhenInUseAuthorization()
    }
    
    // - Delegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        validateLocation(status: manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("DEBUG: Location \(location)")
        
        DispatchQueue.main.async {
            self.lastLocation = location
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), latitudinalMeters: 250, longitudinalMeters: 250)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("DEBUG: \(error.localizedDescription)")
    }
}
