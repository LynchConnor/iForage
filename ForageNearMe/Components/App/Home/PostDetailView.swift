//
//  PostDetailView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 11/10/2021.
//

import SwiftUI
import Firebase

struct PostDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var post: Post
    
    private var isLiked: Bool {
        guard let isLiked = post.isLiked else { return false }
        return isLiked
    }
    
    private func likePost(){
        post.isLiked = true
    }
    
    private func unLikePost(){
        post.isLiked = false
    }
    
    var body: some View {
        VStack {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        
                        StretchingHeader(height: 275) {
                            
                            ZStack {
                                
                                Image("plant")
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                                    .clipped()
                                
                                LinearGradient(colors: [.clear, .black.opacity(0.65)], startPoint: .top, endPoint: .bottom)
                                    .clipped()
                            }
                            .clipped()
                        }

                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Sambucus Nigras")
                                    .italic()
                                    .kerning(1)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color.init(red: 255/255, green: 96/255, blue: 96/255))
                                Text("Elderflower")
                                    .kerning(1)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button {
                                isLiked ? unLikePost() : likePost()
                            } label: {
                                ZStack {
                                    
                                    Circle()
                                        .foregroundColor(.white)
                                    Image(systemName: isLiked ? "heart.fill" : "heart")
                                        .resizable()
                                        .font(.system(size: 18, weight: .medium))
                                        .scaledToFit()
                                        .foregroundColor(isLiked ? .red : .black)
                                        .padding(13)
                                }
                                .frame(width: 50, height: 50)
                            }

                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        
                    }// - ZStack
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack(spacing: 5) {
                            Text("Notes")
                                .kerning(2)
                                .font(.system(size: 18, weight: .semibold))
                            Button {
                                //
                            } label: {
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .aspectRatio(1, contentMode: .fill)
                                    .foregroundColor(.black)
                            }

                        }
                        
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
                            .foregroundColor(Color.black.opacity(0.8))
                            .font(.system(size: 15, weight: .light))
                            .lineSpacing(8)
                        
                    }// - VStack
                    .padding(.vertical, 20)
                    .padding(.horizontal, 15)
                }
                // - VStack
            }
            // - ScrollView
            .overlay(
                
                ZStack {
                    
                    Circle()
                        .opacity(0.75)
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.turn.up.left")
                            .resizable()
                            .font(.system(size: 18, weight: .medium))
                            .scaledToFit()
                            .foregroundColor(.white)
                            .padding(13)
                    }

                }
                .frame(width: 45, height: 45)
                .padding(.top, 50)
                .padding(.horizontal, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ,alignment: .top
            )
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
        PostDetailView(post: .constant(Post(id: UUID().uuidString, name: "", title: "", imageURL: "", isLiked: false, notes: "", location: GeoPoint(latitude: 0, longitude: 0))))
    }
}
