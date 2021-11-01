//
//  MapView.swift
//  iForage
//
//  Created by Connor A Lynch on 01/11/2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        
        mapView.delegate = context.coordinator
        
        let lat = LocationManager.shared.lastLocation?.coordinate.latitude ?? 0
        let lng = LocationManager.shared.lastLocation?.coordinate.longitude ?? 0
        
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng), latitudinalMeters: 200, longitudinalMeters: 200)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, ObservableObject, MKMapViewDelegate {
        var parent: MapView
        
        init(parent: MapView){
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            self.parent.centerCoordinate = mapView.centerCoordinate
        }
    }
}
