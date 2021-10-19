//
//  CreatePostView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 11/10/2021.
//

import SwiftUI
import MapKit
import FirebaseFirestore

extension CreatePostView {
    
    enum PostStatus {
        case processing
        case complete
        case error
    }
    
    class ViewModel: ObservableObject {
        
        @Published var postStatus: PostStatus = .complete
        
        @Published var name: String = ""
        
        @Published var notes: String = "What do you want to say about your find? Tap to write..."
        
        @Published var selectedImage: UIImage?
        
        func uploadPost(){
            guard let id = AuthViewModel.shared.currentUserId else { return }
            
            guard let image = selectedImage else { return }
            
            ImageUploader.uploadImage(image: image) { imageURL in
                
                let post = Post(latinName: "", name: self.name, imageURL: imageURL, notes: self.notes, location: GeoPoint(latitude: 51.877330, longitude: 0.528380))
                
                do {
                    
                    _ = try COLLECTION_USERS.document(id).collection("userPosts").addDocument(from: post)
                }catch {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                print("DEBUG: Sucessfully uploaded!")
            }
        }
        
        private func resetValues(){
            self.name = ""
            self.notes = ""
            self.selectedImage = nil
        }
        
    }
}

struct CreatePostView: View {
    
    @StateObject var viewModel = CreatePostView.ViewModel()
    
    @State var isShowPhotoLibrary: Bool = false
    
    @FocusState private var editorIsFocused: Bool
    
    @EnvironmentObject var locationManager: LocationManager
    
    init() {
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().textContainerInset =
        UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 5) {
                
                Button {
                    isShowPhotoLibrary = true
                } label: {
                    
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(0)
                    }else{
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color.init(red: 239/255, green: 239/255, blue: 239/255))
                            
                            ZStack {
                                Circle()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(Color.init(red: 44/255, green: 108/255, blue: 100/255))
                                Image(systemName: "photo")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .clipped()
                            }// - ZStack
                            .frame(height: 200)
                            .clipShape(Circle())
                            
                        }// - ZStack
                    }
                    
                }// - Button
                .frame(maxWidth: .infinity)
                .cornerRadius(5)
                .padding(.top, 25)
                .clipped()
                
                VStack(spacing: 5) {
                    
                    TextField("Name your plant here...", text: $viewModel.name)
                        .font(.system(size: 21, weight: .semibold))
                        .padding(.vertical, 15)
                    
                    TextEditor(text: $viewModel.notes)
                        .font(.system(size: 16, weight: .regular))
                        .lineSpacing(2)
                        .frame(height: 150)
                        .background(Color.init(red: 239/255, green: 239/255, blue: 239/255))
                        .cornerRadius(5)
                        .focused($editorIsFocused)
                    
                }// - VStack
                
                Button {
                    viewModel.uploadPost()
                } label: {
                    Text("Create Post")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.init(red: 44/255, green: 108/255, blue: 100/255))
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .semibold))
                .cornerRadius(5)
                .padding(.vertical, 10)
                
                
            }// - VStack
            .sheet(isPresented: $isShowPhotoLibrary, content: {
                ImagePicker(selectedImage: $viewModel.selectedImage)
            })
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        editorIsFocused.toggle()
                    } label: {
                        Text("Done")
                    }
                    
                }
            }
            
            
        }// - ScrollView
        // - VStack
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationBarHidden(true)
        .navigationTitle("")
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
            .environmentObject(LocationManager())
    }
}
