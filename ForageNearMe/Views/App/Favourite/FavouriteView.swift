//
//  FavouriteView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 11/10/2021.
//

import SwiftUI

struct FavouriteView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(1...5, id: \.self) { post in
                        Rectangle()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                        
                    }//ForEach
                    
                }// - LazyVGrid
                
            }// - VStack
            .padding(.horizontal, 15)
        }
        // - ScrollView
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct FavouriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteView()
    }
}
