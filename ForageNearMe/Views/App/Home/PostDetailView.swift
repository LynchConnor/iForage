//
//  PostDetailView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 11/10/2021.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

extension PostDetailView {
    class DataService {
        
        static func likePost(id postId: String, completion: @escaping (Error?) -> ()){
            
            guard let userId = AuthViewModel.shared.currentUserId else { return }
            
            COLLECTION_USERS.document(userId).collection("userPosts").document(postId).setData(["didLike": true], merge: true) { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    completion(error)
                    return
                }
            }
        }
        
        static func unlikePost(id postId: String, completion: @escaping (Error?) -> ()){
            
            guard let userId = AuthViewModel.shared.currentUserId else { return }
            
            COLLECTION_USERS.document(userId).collection("userPosts").document(postId).setData(["didLike": false], merge: true) { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    completion(error)
                    return
                }
            }
        }
        
        static func checkIfUserDidLike(){
            //
        }
        
        static func updateNotes(){
            
        }
    }
}

extension PostDetailView {
    class ViewModel: ObservableObject {
        
        // - Public
        
        @Published var post: Post
        
        @Published var isEditing: Bool = false
        
        init(_ post: Post) {
            self.post = post
            checkIfUserDidLike()
            updateNotes()
        }
        
        var didLike: Bool {
            guard let didLike = post.didLike else { return false }
            return didLike
        }
        
        func likePost(){
            
            guard let postId = post.id else { return }
            
            post.didLike = true
            
            PostDetailView.DataService.likePost(id: postId) { [weak self] error in
                if let _ = error {
                    self?.post.didLike = false
                }
            }
        }
        
        func unLikePost(){
            
            guard let postId = post.id else { return }
            
            post.didLike = false
            
            PostDetailView.DataService.unlikePost(id: postId) { [weak self] error in
                if let _ = error {
                    self?.post.didLike = true
                }
            }
            
        }
        
        private func checkIfUserDidLike(){
            
            guard let userId = AuthViewModel.shared.currentUserId else { return }
            
            guard let postId = post.id else { return }
            
            COLLECTION_USERS.document(userId).collection("userPosts").document(postId).getDocument { snapshot, error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                guard let document = snapshot, document.exists else { return }
                
                self.post.didLike = try? document.data(as: Post.self)?.didLike ?? false
            }
        }
        
        private func updateNotes(){
            
            guard let userId = AuthViewModel.shared.currentUserId else { return }
            
            guard let postId = post.id else { return }
            
            COLLECTION_USERS.document(userId).collection("userPosts").document(postId).addSnapshotListener { snapshot, error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                guard let document = snapshot, document.exists else { return }
                
                do {
                    self.post.notes = try document.data(as: Post.self)?.notes ?? ""
                }catch {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
            }
        }
        
        func saveNotes(){
            
            guard let userId = AuthViewModel.shared.currentUserId else { return }
            
            guard let postId = post.id else { return }
            
            let data = [
                "notes": post.notes
            ]
            
            COLLECTION_USERS.document(userId).collection("userPosts").document(postId).setData(data, merge: true) { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                self.isEditing.toggle()
                
                print("DEBUG: Updated notes")
            }
        }
    }
}

struct PostDetailView: View {
    
    @StateObject var viewModel: PostDetailView.ViewModel
    
    init(_ viewModel: PostDetailView.ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().textContainerInset =
                 UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        
                        StretchingHeader(height: 275) {
                            
                            AnimatedImage(url: URL(string: viewModel.post.imageURL))
                                .resizable()
                                .aspectRatio(1, contentMode: .fill)
                                .clipped()
                        }
                        .overlay(
                            
                            LinearGradient(colors: [.clear, .black.opacity(0.65)], startPoint: .top, endPoint: .bottom)
                                .clipped()
                            
                            ,alignment: .bottom
                            
                        )// - Overlay
                        
                        
                        HStack {
                            VStack(alignment: .leading) {
                                //MARK: Latin Name
                                
                                if let name = viewModel.post.latinName {
                                    
                                    Text(name)
                                        .italic()
                                        .kerning(1)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color.init(red: 255/255, green: 96/255, blue: 96/255))
                                        .shadow(color: .black.opacity(0.75), radius: 2, x: 0, y: 0)
                                }
                                
                                //MARK: Name
                                Text(viewModel.post.name)
                                    .kerning(1)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }// - HStack
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        
                    }// - ZStack
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(alignment: .center, spacing: 5) {
                            
                            Text("Notes")
                                .kerning(2)
                                .font(.system(size: 18, weight: .semibold))
                            
                            HStack {
                                
                                if !viewModel.isEditing {
                                    //MARK: Edit
                                    Button {
                                        DispatchQueue.main.async {
                                            viewModel.isEditing.toggle()
                                        }
                                    } label: {
                                        Image(systemName: "square.and.pencil")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .aspectRatio(1, contentMode: .fill)
                                            .foregroundColor(.black)
                                            .padding(5)
                                        
                                    }// - Button
                                    
                                }else{
                                    
                                    Spacer()
                                    
                                    //MARK: Save
                                    Button {
                                        viewModel.saveNotes()
                                    } label: {
                                        Text("Save")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.black)
                                    }

                                }
                            }
                            
                        }// - HStack
                        .padding(.horizontal, 10)
                        
                        //MARK: Notes
                        
                        if !viewModel.isEditing {
                            
                            Text(viewModel.post.notes)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .foregroundColor(Color.black.opacity(0.8))
                                .font(.system(size: 17, weight: .light))
                                .lineSpacing(8)
                                .padding(10)
                                .multilineTextAlignment(.leading)
                        }else{
                            ZStack {
                                TextEditor(text: $viewModel.post.notes)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                    .foregroundColor(Color.black.opacity(0.8))
                                    .font(.system(size: 17, weight: .light))
                                    .lineSpacing(8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(3)
                                    .multilineTextAlignment(.leading)
                                
                                Text(viewModel.post.notes).opacity(0).padding(.all, 8)
                            }
                        }
                        
                    }// - VStack
                    .padding(.vertical, 20)
                    .padding(.horizontal, 10)
                }
                // - VStack
            }
            // - ScrollView
            .overlay(
                
                HStack {
                    
                    ZStack {
                        
                        Circle()
                            .opacity(0.5)
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 17, height: 17)
                                .font(.system(size: 1, weight: .medium))
                                .foregroundColor(.white)
                                .padding(13)
                        }// - Button
                        
                    }
                    // - ZStack
                    .frame(width: 45, height: 45)
                    
                    Spacer()
                    
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
                                .padding(13)
                                .foregroundColor(viewModel.didLike ? .red : .white)
                            
                        }// - ZStack
                        .frame(width: 45, height: 45)
                        
                    }// - Button
                    .buttonStyle(LikeButtonStyle())
                    
                }
                // - HStack
                    .padding(.top, 40)
                    .padding(.horizontal, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ,alignment: .top
            )// - Overlay
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .edgesIgnoringSafeArea(.top)
        .ignoresSafeArea(.all, edges: .top)
        .navigationTitle("")
        .navigationBarHidden(true)
        .statusBar(hidden: true)
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(PostDetailView.ViewModel(DEFAULT_POST))
    }
}

let DEFAULT_POST = Post(id: UUID().uuidString, latinName: "Sambucus Nigras", name: "", imageURL: "", didLike: true, notes: "", location: GeoPoint(latitude: 0, longitude: 0))
