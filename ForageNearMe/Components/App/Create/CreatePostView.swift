//
//  CreatePostView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 11/10/2021.
//

import SwiftUI

struct CreatePostView: View {
    
    @State var name: String = "Name your plant"
    
    @State var notes: String = "What do you want to say about your find? Tap to write..."
    
    init() {
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().textContainerInset =
                 UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 5) {
                
                Button {
                    //
                } label: {
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
                    
                }// - Button
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .cornerRadius(5)
                
                VStack(spacing: 5) {
                    
                    TextField("Name your plant", text: $name)
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.vertical, 10)
                    
                    TextEditor(text: $notes)
                        .font(.system(size: 15, weight: .regular))
                        .frame(height: 250)
                        .background(Color.init(red: 239/255, green: 239/255, blue: 239/255))
                        .cornerRadius(5)
                    
                }// - VStack
                
            }// - VStack
            .padding(.top, 25)
        }// - ScrollView
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationBarHidden(true)
        .navigationTitle("")
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
