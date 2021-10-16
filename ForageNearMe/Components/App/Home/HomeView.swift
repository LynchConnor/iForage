//
//  HomeView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 09/10/2021.
//

import SwiftUI
import MapKit
import Firebase
import FirebaseFirestore

extension HomeView {
    class ViewModel: ObservableObject {
        @Published var posts: [Post] = [Post(id: UUID().uuidString, latinName: "Sambucus Nigras", name: "", imageURL: "", notes: "", location: GeoPoint(latitude: 0, longitude: 0))]
    }
}

struct HomeView: View {
    
    @StateObject var viewModel: HomeView.ViewModel = HomeView.ViewModel()
    
    @State var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 250, longitudinalMeters: 250)
    
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack {
            // - Map
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: $viewModel.posts) { $post in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: 51.876735, longitude: 0.523035)) {
                    NavigationLink {
                        PostDetailView(PostDetailView.ViewModel(post))
                    } label: {
                        MapAnnotationCell()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
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
