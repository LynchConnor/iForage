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


enum DataError: Error {
    case noDocuments
    case error
}

extension HomeView {
    
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
        @Published var posts: [Post]
        
        init(posts: [Post] = []){
            self.posts = posts
            self.fetchPosts()
        }
        
        private func fetchPosts(){
            HomeView.DataService.fetchPosts { [weak self] result in
                switch result {
                    
                    //Was I able to return posts?
                case .success(let posts):
                    print("DEBUG: Posts fetched")
                    self?.posts = posts
                    break
                    
                    //Was I an error?
                case .failure(let error):
                    switch error {
                    case .noDocuments:
                        print("DEBUG: No documents")
                        self?.posts = []
                    case .error:
                        print("DEBUG: Error")
                        self?.posts = []
                    }
                }
            }
        }
    }
}

struct HomeView: View {
    
    @State private var isPresented: Bool = false
    
    @StateObject private var viewModel: HomeView.ViewModel = HomeView.ViewModel()
    
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            // - Map
            Map(coordinateRegion: $locationManager.region, interactionModes: .all, showsUserLocation: true, annotationItems: $viewModel.posts) { $post in

                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: post.location.latitude, longitude: post.location.longitude)) {
                    NavigationLink {
                        PostDetailView(PostDetailView.ViewModel(post))
                    } label: {
                        MapAnnotationCell(post: post)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            
            //Navigation
            HStack(spacing: 25) {
                Button {
                    //
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .resizable()
                        .font(.system(size: 18, weight: .light))
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
                .foregroundColor(Color.black.opacity(0.75))
                
                Spacer()
                
                Button {
                    //
                } label: {
                    Image(systemName: "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
                .foregroundColor(Color.black.opacity(0.75))
                
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: "plus.square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
                .foregroundColor(Color.black.opacity(0.75))
                
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .navigationTitle("")
        .sheet(isPresented: $isPresented){
            CreatePostView()
                .environmentObject(locationManager)
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(LocationManager())
    }
}
