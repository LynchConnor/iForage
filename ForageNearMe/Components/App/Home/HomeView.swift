//
//  HomeView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 09/10/2021.
//

import SwiftUI
import MapKit
import Firebase

struct HomeView: View {
    
    @State var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 250, longitudinalMeters: 250)
    
    @EnvironmentObject var locationManager: LocationManager
    
    @State var posts: [Post] = [Post(id: UUID().uuidString, latinName: "Sambucus Nigras", name: "", imageURL: "", isLiked: false, notes: "", location: GeoPoint(latitude: 0, longitude: 0))]
    
    var body: some View {
        VStack {
            // - Map
            if #available(iOS 15.0, *) {
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: $posts) { $post in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: 51.876735, longitude: 0.523035)) {
                        NavigationLink {
                            PostDetailView(post: $post)
                        } label: {
                            MapAnnotationCell()
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            } else {
                // Fallback on earlier versions
            }
        }
        // - VStack
        .onAppear {
            locationManager.requestLocation()
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationManager.lastLocation?.coordinate.latitude ?? 0, longitude: locationManager.lastLocation?.coordinate.longitude ?? 0), latitudinalMeters: 250, longitudinalMeters: 250)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
