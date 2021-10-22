//
//  CreatePostView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 11/10/2021.
//

import SwiftUI
import MapKit
import Firebase
import FirebaseFirestore

extension CreatePostView {
    
    enum PostStatus {
        case processing
        case complete
        case error
    }
    
    class ViewModel: ObservableObject {
        
        @ObservedObject var locationManager = LocationManager()
        
        @Published var postStatus: PostStatus = .complete
        
        @Published var name: String = ""
        
        @Published var notes: String = "What do you want to say about your find? Tap to write..."
        
        @Published var selectedImage: UIImage?
        
        func uploadPost(completion: @escaping () -> ()){
            
            DispatchQueue.main.async {
                self.postStatus = .processing
                self.locationManager.requestLocation()
            }
            
            guard let id = AuthViewModel.shared.currentUserId else { return }
            
            guard let image = selectedImage else { return }
            
            guard let location = locationManager.lastLocation?.coordinate else { return }
            
            ImageUploader.uploadImage(image: image) { imageURL in
                
                let post = Post(latinName: "", name: self.name, imageURL: imageURL, notes: self.notes, location: GeoPoint(latitude: location.latitude, longitude: location.longitude))
                
                do {
                    
                    _ = try COLLECTION_USERS.document(id).collection("userPosts").addDocument(from: post)
                }catch {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                print("DEBUG: Sucessfully uploaded!")
                
                self.postStatus = .complete
                
                self.resetValues()
                
                completion()
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
    
    @Binding var isPresented: Bool
    
    @StateObject var viewModel = CreatePostView.ViewModel()
    
    @State var isShowPhotoLibrary: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @FocusState private var editorIsFocused: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().textContainerInset =
        UIEdgeInsets(top: -5, left: -5, bottom: 0, right: 0)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            ZStack {
                
                VStack(spacing: 5) {
                    
                    HStack {
                        Button {
                            isPresented.toggle()
                        } label: {
                            Text("Cancel")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .padding(.vertical, 15)
                        Spacer()
                        
                        Button {
                            viewModel.uploadPost() {
                                isPresented.toggle()
                            }
                        } label: {
                            Text("Create Post")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 18)
                                .background(Color.blue)
                        }
                        .cornerRadius(5)
                    }
                    
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
                    .clipped()
                    
                    VStack(spacing: 5) {
                        
                        TextField("Name your plant here...", text: $viewModel.name)
                            .font(.system(size: 21, weight: .semibold))
                            .padding(.vertical, 15)
                        
                        TextEditor(text: $viewModel.notes)
                            .font(.system(size: 18, weight: .regular))
                            .lineSpacing(8)
                            .frame(height: 150)
                            .cornerRadius(5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }// - VStack
                    
                }// - VStack
                .disabled(viewModel.postStatus == .processing)
                .opacity((viewModel.postStatus == .processing) ? 0.5 : 1)
                
                if viewModel.postStatus == .processing {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
            }// - VStack
            
            
        }// - ScrollView
        .sheet(isPresented: $isShowPhotoLibrary, content: {
            ImagePicker(selectedImage: $viewModel.selectedImage)
        })
        // - VStack
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationBarHidden(true)
        .navigationTitle("")
        .background(Color.white)
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(isPresented: .constant(true))
            .environmentObject(LocationManager())
    }
}
