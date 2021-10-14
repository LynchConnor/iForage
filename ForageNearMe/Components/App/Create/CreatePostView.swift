//
//  CreatePostView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 11/10/2021.
//

import SwiftUI
import MapKit

struct CreatePostView: View {
    
    @State var selectedImage: UIImage?
    
    @State var isShowPhotoLibrary: Bool = false
    
    @EnvironmentObject var locationManager: LocationManager
    
    @State var name: String = "Name your plant here..."
    
    @State var notes: String = "What do you want to say about your find? Tap to write..."
    
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
                    
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .clipped()
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
                            }// - ZStack
                            .clipShape(Circle())
                            
                        }// - ZStack
                    }
                    
                }// - Button
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(5)
                .padding(.top, 25)
                
                VStack(spacing: 5) {
                    
                    TextField("Name your plant here...", text: $name)
                        .font(.system(size: 21, weight: .semibold))
                        .padding(.vertical, 15)
                    
                    TextEditor(text: $notes)
                        .font(.system(size: 15, weight: .regular))
                        .lineSpacing(2)
                        .frame(height: 150)
                        .background(Color.init(red: 239/255, green: 239/255, blue: 239/255))
                        .cornerRadius(5)
                    
                }// - VStack
                
                Button {
                    
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
                ImagePicker(selectedImage: $selectedImage)
            })
            
            
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
