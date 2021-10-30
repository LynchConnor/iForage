//
//  MapAnnotationCell.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 10/10/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct MapAnnotationCell: View {
    
    let post: Post
    
    var body: some View {
        VStack(spacing: 0) {
            AnimatedImage(url: URL(string: post.imageURL))
                .resizable()
                .frame(width: 45, height: 45)
                .scaledToFill()
                .clipShape(Circle())
                .padding(0)
                .overlay(
                    Circle()
                        .stroke(Color.theme.cardBackground, lineWidth: 3)
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 0)
                )
            
            Text(post.name)
                .foregroundColor(Color.theme.accent)
                .font(.system(size: 13, weight: .semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 3)
                .background(Color.theme.cardBackground)
                .cornerRadius(5)
        }
    }
}

struct MapAnnotationCell_Previews: PreviewProvider {
    static var previews: some View {
        MapAnnotationCell(post: DEFAULT_POST)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
