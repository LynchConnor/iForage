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
    
    @State var posts: [Post] = [Post(id: UUID().uuidString, name: "", title: "", imageURL: "", isLiked: false, notes: "", location: GeoPoint(latitude: 0, longitude: 0))]
    
    // - Public
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            // - Map
            if #available(iOS 15.0, *) {
                Map(coordinateRegion: $locationManager.region, interactionModes: .all, showsUserLocation: true, annotationItems: $posts) { $post in
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
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
