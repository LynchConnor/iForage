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
        
        @Published var shouldPresentMap = false
        
        @Published var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: LocationManager.shared.lastLocation?.coordinate.latitude ?? 0, longitude: LocationManager.shared.lastLocation?.coordinate.longitude ?? 0)
        
        @Published var postStatus: PostStatus = .complete
        
        @Published var name: String = ""
        
        @Published var notes: String = "What do you want to say about your find? Tap to write..."
        
        @Published var selectedImage: UIImage?
        
        func uploadPost(completion: @escaping () -> ()){
            
            DispatchQueue.main.async {
                self.postStatus = .processing
                LocationManager.shared.requestLocation()
            }
            
            guard let id = AuthViewModel.shared.currentUserId else { return }
            
            guard let image = selectedImage else { return }
            
            ImageUploader.uploadImage(image: image) { imageURL in
                
                let post = Post(name: self.name, imageURL: imageURL, notes: self.notes, location: GeoPoint(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude))
                
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
    
    enum Field {
        case title
        case notes
    }
    
    @State private var shouldPresentCamera = false
    
    @Binding var isPresented: Bool
    
    @State var presentConfirmationSheet: Bool = false
    
    @StateObject var viewModel = CreatePostView.ViewModel()
    
    @State var isShowImagePicker: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @FocusState private var focusField: Field?
    
    @FocusState private var editorIsFocused: Bool
    
    @State var containerHeight: CGFloat = 200
    
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
                            hideKeyboard()
                        } label: {
                            Text("Cancel")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color.theme.accent)
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
                        .disabled(viewModel.selectedImage == nil || viewModel.name == "" || viewModel.notes == "" || viewModel.notes ==  "What do you want to say about your find? Tap to write...")
                        .opacity(viewModel.selectedImage == nil || viewModel.name == "" || viewModel.notes == "" || viewModel.notes ==  "What do you want to say about your find? Tap to write..." ? 0.6 : 1)
                    }
                    .padding(.vertical, 10)
                    
                    Button {
                        presentConfirmationSheet = true
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
                                    .foregroundColor(Color.onboarding.textfield)
                                
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
                    .confirmationDialog("Choose your preferred media", isPresented: $presentConfirmationSheet, titleVisibility: .visible) {
                        Button {
                            self.shouldPresentCamera = true
                            self.isShowImagePicker = true
                        } label: {
                            Text("Camera")
                        }
                        
                        Button {
                            self.shouldPresentCamera = false
                            self.isShowImagePicker = true
                        } label: {
                            Text("Photo Library")
                        }

                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(5)
                    .clipped()
                    
                    VStack(spacing: 5) {
                        
                        TextField("Name your plant here...", text: $viewModel.name)
                            .focused($focusField, equals: .title)
                            .submitLabel(.continue)
                            .tint(Color.theme.accent)
                            .font(.system(size: 22, weight: .semibold))
                            .padding(.vertical, 15)
                            .foregroundColor(Color.theme.accent)
                            .accentColor(Color.theme.accent)
                        
                        AutoSizeTextField(text: $viewModel.notes, hint: "What do you want to say about your find? Tap to write...", containerHeight: $containerHeight) {
                            hideKeyboard()
                        }
                        .accentColor(Color.theme.accent)
                            .frame(height: containerHeight)
                            .focused($focusField, equals: .notes)
                            .submitLabel(.continue)
                            .tint(Color.theme.accent)
                            .lineSpacing(8)
                            .cornerRadius(5)
                            .frame(maxWidth: .infinity, minHeight: 200, alignment: .topLeading)
                        
                    }// - VStack
                    .onSubmit {
                        switch focusField {
                            case .title:
                                focusField = .notes
                            default:
                                return
                        }
                    }
                    
                    VStack(spacing: 15) {
                        
                        HStack(spacing: 0) {
                            Text("Use current location?")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(viewModel.shouldPresentMap ? "No" : "Yes")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.gray)
                                
                            Toggle(isOn: $viewModel.shouldPresentMap) {
                                    Text("")
                                }
                                .frame(width: 60)
                        }
                        .padding(.trailing, 10)
                        
                            
                        if viewModel.shouldPresentMap {
                            
                            ZStack {
                                
                                MapView(centerCoordinate: $viewModel.centerCoordinate)
                                    .frame(height: 150)
                                    .cornerRadius(10)
                                
                                
                                Circle()
                                    .foregroundColor(.blue)
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .opacity(0.5)
                                
                            }
                        }
                        
                    }

                    
                }// - VStack
                .disabled(viewModel.postStatus == .processing)
                .opacity((viewModel.postStatus == .processing) ? 0.5 : 1)
                
                if viewModel.postStatus == .processing {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
            }// - VStack
            
            
        }// - ScrollView
        .sheet(isPresented: $isShowImagePicker, content: {
            ImagePicker(selectedImage: $viewModel.selectedImage, isPresented: $isShowImagePicker, sourceType: self.shouldPresentCamera ? .camera : .photoLibrary) {
                focusField = .title
            }
                .edgesIgnoringSafeArea(.all)
        })
        // - VStack
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationBarHidden(true)
        .navigationTitle("")
        .background(Color.theme.background)
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(isPresented: .constant(true))
            .environmentObject(LocationManager())
            .preferredColorScheme(.dark)
    }
}
