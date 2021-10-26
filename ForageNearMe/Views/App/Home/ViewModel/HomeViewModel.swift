//
//  ViewModel.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 26/10/2021.
//

import Foundation
import SwiftUI

extension AnyTransition {
    static var customTransition: AnyTransition {
        let transition = AnyTransition.move(edge: .bottom)
            .combined(with: .opacity)
        return transition
    }
}

extension AnyTransition {
    static var customCancelTransition: AnyTransition {
        let transition = AnyTransition.move(edge: .trailing)
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
        
        // -  PUBLIC
        @Published var searchIsActive: Bool
        @Published var searchText: String = ""
        @Published var posts: [Post]
        
        // - INIT
        init(posts: [Post] = [], searchIsActive: Bool = false){
            self.posts = posts
            self.searchIsActive = searchIsActive
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
        
        var filteredPosts: [Post] {
            let query = searchText.lowercased()
            return searchText.isEmpty ? posts : posts.filter( { $0.name.lowercased().contains(query) })
        }
    }
}
