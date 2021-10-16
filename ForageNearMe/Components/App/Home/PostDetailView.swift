//
//  PostDetailView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 11/10/2021.
//

import SwiftUI
import Firebase

class PostDataService {
    static func likePost(){
        
    }
}

extension PostDetailView {
    class ViewModel: ObservableObject {
        
        @Published var post: Post
        
        init(_ post: Post) {
            self.post = post
        }
        
        var didLike: Bool {
            guard let didLike = post.didLike else { return false }
            return didLike
        }
        
        func likePost(){
            post.didLike = true
        }
        
        func unLikePost(){
            post.didLike = false
        }
        
        func checkIfUserDidLike(){
            //
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
    
    @State var isEditing: Bool = false
    
    @State var text: String = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
    """
    
    var body: some View {
        VStack {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        
                        StretchingHeader(height: 275) {
                            
                            Image("plant")
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
                                Text("Elderflower")
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
                        HStack(alignment: .top, spacing: 5) {
                            
                            Text("Notes")
                                .kerning(2)
                                .font(.system(size: 18, weight: .semibold))
                            
                            HStack {
                                
                                if !isEditing {
                                    //MARK: Edit
                                    Button {
                                        DispatchQueue.main.async {
                                            isEditing.toggle()
                                        }
                                    } label: {
                                        Image(systemName: "square.and.pencil")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .aspectRatio(1, contentMode: .fill)
                                            .foregroundColor(.black)
                                        
                                    }// - Button
                                    
                                }else{
                                    
                                    Spacer()
                                    
                                    //MARK: Save
                                    Button {
                                        DispatchQueue.main.async {
                                            isEditing.toggle()
                                        }
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
                        
                        if !isEditing {
                            
                            Text("\(text)")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundColor(Color.black.opacity(0.8))
                                .font(.system(size: 15, weight: .light))
                                .lineSpacing(8)
                                .padding(10)
                        }else{
                            ZStack {
                                TextEditor(text: $text)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .foregroundColor(Color.black.opacity(0.8))
                                    .font(.system(size: 15, weight: .light))
                                    .lineSpacing(8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(3)
                                
                                Text(text).opacity(0).padding(.all, 8)
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

let DEFAULT_POST = Post(id: UUID().uuidString, latinName: "Sambucus Nigras", name: "", imageURL: "", didLike: true, notes: "")
