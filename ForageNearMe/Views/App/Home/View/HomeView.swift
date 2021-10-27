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
import FirebaseFirestoreSwift
import SDWebImageSwiftUI

struct HomeView: View {
    
    @State var isActive: Bool = false
    
    @State private var isPresented: Bool = false
    
    @StateObject var viewModel: HomeView.ViewModel = HomeView.ViewModel()
    
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            // - Map
            Map(coordinateRegion: $locationManager.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(MapUserTrackingMode.follow), annotationItems: $viewModel.posts) { $post in
                
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: post.location.latitude, longitude: post.location.longitude)) {
                    
                    NavigationLink{
                        LazyView(PostDetailView(PostDetailView.ViewModel(post)))
                    } label: {
                        MapAnnotationCell(post: post)
                    }
                    .isDetailLink(false)
                    
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            //Create Post View
            .overlay (
                
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .padding(18)
                        .background(Color.black)
                        .clipShape(Circle())
                        .padding(5)
                }
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 0)
                    .padding(15)
                ,alignment: .bottomTrailing
            )
            
            
            //Navigation
            HStack(spacing: 25) {
                
                NavigationLink {
                    ExploreView()
                        .environmentObject(viewModel)
                        .environmentObject(locationManager)
                        .transition(.fade(duration: 0.25))
                        .animation(.easeInOut, value: viewModel.searchIsActive)
                } label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
                .isDetailLink(false)
                .foregroundColor(Color.black.opacity(0.75))
                
                Spacer()
                
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .resizable()
                        .font(.system(size: 18, weight: .light))
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
                .isDetailLink(false)
                .foregroundColor(Color.black.opacity(0.75))
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .navigationTitle("")
        .onDisappear { viewModel.searchIsActive = false }
        .overlay(
            VStack {
                if isPresented {
                    CreatePostView(isPresented: $isPresented)
                        .edgesIgnoringSafeArea(.bottom)
                        .transition(.customTransition)
                        .animation(.easeInOut(duration: 0.25), value: isPresented)
                }
            }
                .animation(.easeInOut, value: isPresented)
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeView.ViewModel(posts: [Post(id: UUID().uuidString, name: "Elderflower", imageURL: "https://firebasestorage.googleapis.com:443/v0/b/foragenearme.appspot.com/o/post_images%2FF2A86825-BE3F-42D7-B631-1685D1795E74?alt=media&token=592b9723-be4a-44fc-a8d0-2ecfbb99b979", didLike: false, notes: "", location: GeoPoint(latitude: 0, longitude: 0)), Post(id: UUID().uuidString, name: "Elderflower", imageURL: "https://firebasestorage.googleapis.com:443/v0/b/foragenearme.appspot.com/o/post_images%2FF2A86825-BE3F-42D7-B631-1685D1795E74?alt=media&token=592b9723-be4a-44fc-a8d0-2ecfbb99b979", didLike: false, notes: "", location: GeoPoint(latitude: 0, longitude: 0))], searchIsActive: true))
            .environmentObject(LocationManager())
    }
}
