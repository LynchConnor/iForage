//
//  ExplorePostCell.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 26/10/2021.
//

import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI
import CoreLocation

struct ExplorePostCell: View {
    
    @StateObject var viewModel: ExplorePostCell.ViewModel
    
    init(viewModel: ExplorePostCell.ViewModel){
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        if let post = viewModel.post {
            
            HStack(spacing: 0) {
                WebImage(url: URL(string: post.imageURL))
                    .resizable()
                    .frame(width: 115, height: 115, alignment: .center)
                    .scaledToFill()
                    .clipped()
                    .cornerRadius(5, corners: [.bottomLeft, .topLeft])
                    .overlay(
                        
                        Button {
                            viewModel.didLike ? viewModel.unLikePost() : viewModel.likePost()
                        } label: {
                            ZStack {
                                
                                Circle()
                                    .foregroundColor(Color.black.opacity(0.5))
                                
                                Image(systemName: viewModel.didLike ? "heart.fill" : "heart")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .font(.system(size: 16, weight: .medium))
                                    .padding(8)
                                    .foregroundColor(viewModel.didLike ? .red : .white)
                                
                            }// - ZStack
                            .frame(width: 35, height: 35)
                            
                        }// - Button
                            .buttonStyle(LikeButtonStyle())
                            .padding(5)
                        
                        ,alignment: .bottomTrailing
                    )
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(post.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.theme.accent)
                    
                    Text(post.notes.prefix(50))
                        .lineLimit(2)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color.theme.accent)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxHeight: .infinity, alignment: .topLeading)
                    
                    HStack {
                        
                        Spacer()
                    
                    HStack(spacing: 2) {
                        Image("map.pin")
                            .resizable()
                            .frame(width: 18, height: 18)
                        Text(viewModel.distance)
                    }
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.gray)
                        
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
            }
            .frame(maxWidth: .infinity, maxHeight: 115, alignment: .leading)
            .background(Color.theme.cardBackground)
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 0)
        }
    }
}

extension ExplorePostCell {
    class ViewModel: ObservableObject {
        
        // - Public
        @Published var post: Post?
        @Published var distance: String = "0.0mi"
        
        // - Private
        var location: CLLocation?
        
        init(post: Post, location: CLLocation?) {
            self.post = post
            self.location = location
            checkIfUserDidLike()
            self.distance = fetchDistance()
        }
        
        private let suffix = ["mi", "km", "mm", "gm"]
        
        private func formatNumber(_ number: Double) -> String{
            var index = 0
            var value = number
            while((value / 1000) >= 1){
                value = value / 1000
                index += 1
            }
            return String(format: "%.1f%@", value, suffix[index])
        }
        
        func fetchDistance() -> String {
            guard let locationA = location else {
                return "0.0mi"
            }
            
            guard let locationB = post?.location else { return "0.0mi" }
            
            let distance = locationA.distance(from: CLLocation(latitude: locationB.latitude, longitude: locationB.longitude))
            
            return "\(formatNumber(distance))"
            
        }
        
        var didLike: Bool {
            guard let didLike = post?.didLike else { return false }
            return didLike
        }
        
        func likePost(){
            
            guard let postId = post?.id else { return }
            
            post?.didLike = true
            
            PostDetailView.DataService.likePost(id: postId) { [weak self] error in
                if let _ = error {
                    self?.post?.didLike = false
                }
            }
        }
        
        func unLikePost(){
            
            guard let postId = post?.id else { return }
            
            post?.didLike = false
            
            PostDetailView.DataService.unlikePost(id: postId) { [weak self] error in
                if let _ = error {
                    self?.post?.didLike = true
                }
            }
            
        }
        
        private func checkIfUserDidLike(){
            
            guard let userId = AuthViewModel.shared.currentUserId else { return }
            
            guard let postId = post?.id else { return }
            
            COLLECTION_USERS.document(userId).collection("userPosts").document(postId).addSnapshotListener { snapshot, error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                guard let document = snapshot, document.exists else { return }
                
                self.post?.didLike = try? document.data(as: Post.self)?.didLike ?? false
            }
        }
    }
}

struct ExplorePostCell_Previews: PreviewProvider {
    static var previews: some View {
        ExplorePostCell(viewModel: ExplorePostCell.ViewModel(post: Post(id: UUID().uuidString, name: "", imageURL: "", didLike: false, notes: "", location: GeoPoint(latitude: 0, longitude: 0)), location: CLLocation(latitude: 0, longitude: 0)))
    }
}
