//
//  OnboardingView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 08/10/2021.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .center) {
                Text("Forage The World world around you".uppercased())
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 0)
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(.white)
            .font(.system(size: 32, weight: .heavy))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .padding(25)
        .background(
            Image("plant")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.35)
        )
        .background(Color.black.opacity(0.75).edgesIgnoringSafeArea(.all))
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WelcomeView()
        }
    }
}
