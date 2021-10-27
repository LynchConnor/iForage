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
    
    // - Public
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation? = nil
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 250, longitudinalMeters: 250)
    
    @Published var region2: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 250, longitudinalMeters: 250)
    
    private var locationIsDisabled: Bool {
        switch locationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return false
        case .denied, .notDetermined, .none, .restricted:
            return true
        case .some(_):
            return false
        }
    }
    
    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.manager.startUpdatingLocation()
        
        if locationIsDisabled { self.manager.requestAlwaysAuthorization() }
    }
    
    func requestLocation(){
        self.manager.requestLocation()
    }
    
    // - Delegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.locationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("DEBUG: Location \(location)")
        
        DispatchQueue.main.async {
            self.lastLocation = location
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), latitudinalMeters: 250, longitudinalMeters: 250)
            self.region2 = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), latitudinalMeters: 250, longitudinalMeters: 250)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("DEBUG: \(error.localizedDescription)")
    }
}
