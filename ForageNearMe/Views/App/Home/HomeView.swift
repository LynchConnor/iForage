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
    
extension HomeView {
    
    enum DataError: Error {
        case noDocuments
        case error
    }
    
    class DataService {
        static func fetchPosts(completion: @escaping (Result<[Post], DataError>) -> ()){
            
            //Fetch all posts by the currently signed in user
            guard let id = AuthViewModel.shared.currentUserId else { return }
            
            COLLECTION_USERS.document(id).collection("userPosts").getDocuments { snapshot, error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                //Any documents returned?
                guard let documents = snapshot?.documents, !(documents.isEmpty) else { completion(.failure(.noDocuments)); return }
                
                //Able to convert document to a post?
                do {
                    let posts = try documents.compactMap({ try $0.data(as: Post.self) })
                    completion(.success(posts))
                }catch {
                    print("DEBUG: \(error.localizedDescription)")
                    completion(.failure(.error))
                }
                
            }
        }
    }
}

extension HomeView {
    class ViewModel: ObservableObject {
        @Published var posts: [Post] = []
        
        init(){
            self.fetchPosts()
        }
        
        func fetchPosts(){
            HomeView.DataService.fetchPosts { result in
                switch result {
                    
                //Was I able to return posts?
                case .success(let posts):
                    print("DEBUG: Posts fetched")
                    self.posts = posts
                    break
                    
                //Was I an error?
                case .failure(let error):
                    switch error {
                    case .noDocuments:
                        print("DEBUG: No documents")
                        self.posts = []
                    case .error:
                        print("DEBUG: Error")
                        self.posts = []
                    }
                }
            }
        }
    }
}

struct HomeView: View {
    
    @StateObject var viewModel: HomeView.ViewModel = HomeView.ViewModel()
    
    @State var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 250, longitudinalMeters: 250)
    
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        
        VStack {
            //Navigation
            HStack {
                Button {
                    //
                } label: {
                    Image(systemName: "line.3.horizontal")
                }

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            
            // - Map
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: $viewModel.posts) { $post in
                
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: post.location.latitude, longitude: post.location.longitude)) {
                    NavigationLink {
                        PostDetailView(PostDetailView.ViewModel(post))
                    } label: {
                        MapAnnotationCell(post: post)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
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
