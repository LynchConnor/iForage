//
//  MapView.swift
//  iForage
//
//  Created by Connor A Lynch on 01/11/2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.region = LocationManager.shared.region
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(parent: MapView){
            self.parent = parent
        }
    }
}
