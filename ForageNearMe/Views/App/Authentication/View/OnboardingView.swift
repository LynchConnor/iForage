//
//  OnboardingView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 16/10/2021.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        ZStack {
            
            Image("plant")
                .resizable()
                .opacity(0.75)
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .clipped()
            
            VStack(spacing: 15) {
                VStack(alignment: .center, spacing: 15) {
                    Text("iForage")
                        .foregroundColor(.white)
                        .font(.system(size: 60, weight: .heavy))
                        .shadow(color: Color.black, radius: 5, x: 0, y: 0)
                    
                    Text("Your handheld tool for keeping track of foraging spots.")
                        .foregroundColor(.white)
                        .font(.system(size: 21, weight: .bold))
                        .shadow(color: Color.black, radius: 5, x: 0, y: 0)
                        .multilineTextAlignment(.center)
                }
                    .frame(maxHeight: .infinity, alignment: .center)
                
                NavigationLink {
                    LoginView()
                } label: {
                    Text("LOGIN")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.onboarding.buttonBackground)
                }
                .cornerRadius(20)
                
                NavigationLink {
                    CreateAccountView()
                } label: {
                    Text("CREATE ACCOUNT")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.onboarding.buttonBackground)
                }
                .cornerRadius(20)
            }
            .padding(25)
            .padding(.bottom, 25)
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.onboarding.buttonBackground)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .preferredColorScheme(.light)
    }
}
