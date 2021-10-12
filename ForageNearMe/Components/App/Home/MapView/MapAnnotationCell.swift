//
//  MapAnnotationCell.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 10/10/2021.
//

import SwiftUI

struct MapAnnotationCell: View {
    var body: some View {
        VStack(spacing: 0) {
            Image("plant")
                .resizable()
                .frame(width: 45, height: 45)
                .scaledToFill()
                .clipShape(Circle())
                .padding(0)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 0)
                )
            
            Text("Elderflower")
                .foregroundColor(.black)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 3)
                .background(Color.white)
                .cornerRadius(5)
        }
    }
}

struct MapAnnotationCell_Previews: PreviewProvider {
    static var previews: some View {
        MapAnnotationCell()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
