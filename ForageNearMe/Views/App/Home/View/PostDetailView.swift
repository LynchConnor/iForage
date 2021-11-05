//
//  PostDetailView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 11/10/2021.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import Combine

extension PostDetailView {
    class DataService {
        
        static let shared = DataService()
        
        static func likePost(id postId: String) async {
            guard let userId = AuthViewModel.shared.currentUserId else { return }
            do {
                try await COLLECTION_USERS.document(userId).collection("userPosts").document(postId).setData(["didLike": true], merge: true)
            }catch {
                print("DEBUG: \(error.localizedDescription)")
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
    }
}

extension PostDetailView {
    class ViewModel: ObservableObject {
        
        // - Public
        
        var cancellables = Set<AnyCancellable>()
        
        @Published var notes: String = ""
        
        @Published var post: Post?
        
        @Published var isEditing: Bool = false
        
        init(_ post: Post) {
            self.post = post
            checkIfUserDidLike()
            updateNotes()
        }
        
        var didLike: Bool {
            guard let didLike = post?.didLike else { return false }
            return didLike
        }
        
        func likePost(){
            
            guard let postId = post?.id else { return }
            
            post?.didLike = true
            
            Task.init(priority: .userInitiated) {
                await PostDetailView.DataService.likePost(id: postId)
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
            
            COLLECTION_USERS.document(userId).collection("userPosts").document(postId).getDocument { snapshot, error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                guard let document = snapshot, document.exists else { return }
                
                self.post?.didLike = try? document.data(as: Post.self)?.didLike ?? false
            }
        }
        
        private func updateNotes(){
            
            guard let userId = AuthViewModel.shared.currentUserId else { return }
            
            guard let postId = post?.id else { return }
            
            COLLECTION_USERS.document(userId).collection("userPosts").document(postId).addSnapshotListener { snapshot, error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                guard let document = snapshot, document.exists else { return }
                
                do {
                    self.notes = try document.data(as: Post.self)?.notes ?? ""
                }catch {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
            }
        }
        
        func deletePost(completion: @escaping () -> ()){
            
            guard let userId = AuthViewModel.shared.currentUserId else { return }
            
            guard let postId = post?.id else { return }
            
            COLLECTION_USERS.document(userId).collection("userPosts").document(postId).delete { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                completion()
            }
        }
        
        func saveNotes(){
            
            guard let userId = AuthViewModel.shared.currentUserId else { return }
            
            guard let postId = post?.id else { return }
            
            let data = [
                "notes": notes
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
    
    @State var confirmationShown: Bool = false
    
    init(_ viewModel: PostDetailView.ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().textContainerInset =
        UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack {
            
            if let post = viewModel.post {
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottom) {
                            
                            StretchingHeader(height: 275) {
                                
                                AnimatedImage(url: URL(string: post.imageURL))
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                                    .clipped()
                            }
                            .overlay(
                                
                                LinearGradient(colors: [.clear, .clear, .black.opacity(0.15), .black.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                                    .clipped()
                                
                                ,alignment: .bottom
                                
                            )// - Overlay
                            
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    
                                    //MARK: Name
                                    Text(post.name)
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
                                    
                                    if viewModel.isEditing {
                                        
                                        Spacer()
                                        
                                        //MARK: Save
                                        Button {
                                            viewModel.saveNotes()
                                        } label: {
                                            Text("Save")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(Color.theme.accent)
                                        }
                                        
                                    }
                                }
                                
                            }// - HStack
                            .padding(.horizontal, 10)
                            
                            //MARK: Notes
                            
                            if !viewModel.isEditing {
                                
                                Text(viewModel.notes)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                    .foregroundColor(Color.theme.accent)
                                    .font(.system(size: 17, weight: .light))
                                    .lineSpacing(8)
                                    .padding(10)
                                    .multilineTextAlignment(.leading)
                            }else{
                                ZStack {
                                    TextEditor(text: $viewModel.notes)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                        .foregroundColor(Color.theme.accent)
                                        .font(.system(size: 17, weight: .light))
                                        .lineSpacing(8)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(3)
                                        .multilineTextAlignment(.leading)
                                    
                                    Text(viewModel.notes).opacity(0).padding(.all, 8)
                                }
                            }
                            
                            Spacer()
                            
                        }// - VStack
                        .padding(.vertical, 20)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                    
                    // - VStack
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .background(Color.theme.background)
                // - ScrollView
                .overlay(
                    
                    HStack(alignment: .top) {
                        
                        ZStack {
                            
                            Circle()
                                .foregroundColor(Color.black.opacity(0.5))
                            
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
                        
                        Menu {
                            
                            Button {
                                viewModel.isEditing.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "square.and.pencil")
                                    Text("Edit Notes")
                                }
                            }
                            
                            Button(role: .destructive) {
                                
                                confirmationShown = true
                                
                            } label: {
                                HStack {
                                    Image(systemName: "xmark.bin")
                                    Text("Delete")
                                }
                            }

                            
                        } label: {
                            
                                ZStack {
                                    
                                    Circle()
                                        .foregroundColor(Color.black.opacity(0.5))
                                    
                                    Image(systemName: "ellipsis")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .font(.system(size: 16, weight: .medium))
                                        .padding(13)
                                        .foregroundColor(.white)
                                    
                                }// - ZStack
                                .frame(width: 45, height: 45)
                        }
                        .frame(width: 45, height: 45)

                        
                    }
                    // - HStack
                        .padding(.top, 40)
                        .padding(.horizontal, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ,alignment: .top
                )// - Overlay
                
                .confirmationDialog("Are you sure?", isPresented: $confirmationShown, titleVisibility: .visible) {
                    Button("Yes") {
                        viewModel.deletePost {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                
                
            }//IF LET POST
            else{
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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

let DEFAULT_POST = Post(id: UUID().uuidString, name: "", imageURL: "", didLike: true, notes: "", location: GeoPoint(latitude: 0, longitude: 0))
