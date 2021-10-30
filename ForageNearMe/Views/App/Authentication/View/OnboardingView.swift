//
//  OnboardingView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 16/10/2021.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            NavigationLink {
                LoginView()
            } label: {
                Text("LOGIN")
                    .font(.system(size: 18, weight: .bold))
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.theme.cardBackground)
            }
            .cornerRadius(20)
            .padding(.horizontal, 20)
            
            NavigationLink {
                CreateAccountView()
            } label: {
                Text("CREATE ACCOUNT")
                    .font(.system(size: 18, weight: .bold))
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.theme.cardBackground)
            }
            .cornerRadius(20)
            .padding(.horizontal, 20)
        }
        .edgesIgnoringSafeArea(.all)
        .padding(.bottom, 15)
        .background(Color.theme.background)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
