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

extension AnyTransition {
    static var customTransition: AnyTransition {
        let transition = AnyTransition.move(edge: .bottom)
            .combined(with: .opacity)
        return transition
    }
}

enum DataError: Error {
    case noDocuments
    case error
}

extension HomeView {
    
    class DataService {
        static func fetchPosts(completion: @escaping (Result<[Post], DataError>) -> ()){
            
            //Fetch all posts by the currently signed in user
            guard let id = AuthViewModel.shared.currentUserId else { return }
            
            COLLECTION_USERS.document(id).collection("userPosts").addSnapshotListener { snapshot, error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents, !(documents.isEmpty) else {
                    completion(.failure(.noDocuments))
                    return
                }
                
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
        
        @Published var searchText: String = ""
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
    
    @StateObject var viewModel: HomeView.ViewModel = HomeView.ViewModel()
    
    @EnvironmentObject var locationManager: LocationManager
    
    @State var searchIsActive: Bool = false
    
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
                        .background(Color.blue)
                }
                    .clipShape(Circle())
                    .padding(15)
                ,alignment: .bottomTrailing
            )
            
            VStack {
                if searchIsActive {
                    SearchView()
                        .environmentObject(viewModel)
                        .transition(.fade(duration: 0.25))
                        .animation(.easeInOut, value: searchIsActive)
                }
            }
            
            
            //Navigation
            HStack(spacing: 25) {
                HStack {
                    Button {
                        withAnimation {
                            searchIsActive.toggle()
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    .foregroundColor(Color.black.opacity(0.75))
                    
                    TextField("howdy", text: $viewModel.searchText)
                        .font(.system(size: 19))
                        .frame(width: searchIsActive ? 250 : 0 )
                        .transition(.fade)
                        .animation(.easeInOut, value: searchIsActive)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                NavigationLink {
                    Text("")
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .resizable()
                        .font(.system(size: 18, weight: .light))
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
                .foregroundColor(Color.black.opacity(0.75))
                
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .navigationTitle("")
        .onDisappear { searchIsActive = false }
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
        HomeView(viewModel: HomeView.ViewModel(posts: [Post(id: UUID().uuidString, latinName: "", name: "Elderflower", imageURL: "https://firebasestorage.googleapis.com:443/v0/b/foragenearme.appspot.com/o/post_images%2FF2A86825-BE3F-42D7-B631-1685D1795E74?alt=media&token=592b9723-be4a-44fc-a8d0-2ecfbb99b979", didLike: false, notes: "", location: GeoPoint(latitude: 0, longitude: 0)), Post(id: UUID().uuidString, latinName: "", name: "Elderflower", imageURL: "https://firebasestorage.googleapis.com:443/v0/b/foragenearme.appspot.com/o/post_images%2FF2A86825-BE3F-42D7-B631-1685D1795E74?alt=media&token=592b9723-be4a-44fc-a8d0-2ecfbb99b979", didLike: false, notes: "", location: GeoPoint(latitude: 0, longitude: 0))]), searchIsActive: false)
            .environmentObject(LocationManager())
    }
}

struct SearchView: View {
    
    @EnvironmentObject var viewModel: HomeView.ViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]) {
                    ForEach(viewModel.posts){ post in
                        ZStack(alignment: .bottomTrailing) {
                            WebImage(url: URL(string: post.imageURL))
                                .resizable()
                                .scaledToFill()
                                .clipped()
                            
                            Button {
                                //
                            } label: {
                                Image(systemName: "heart")
                                    .resizable()
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFill()
                                    .frame(width: 20, height: 20)
                                    .padding(12)
                                    .background(Color.black.opacity(0.5))
                            }
                            .clipShape(Circle())
                            .padding(5)
                            
                        }
                        .cornerRadius(10)
                    }
                }
                .padding(.top, 65)
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .background(Color.white)
    }
}
