//
//  OnboardingView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 16/10/2021.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack {
            Spacer()
            
            NavigationLink {
                LoginView()
            } label: {
                Text("Log in")
            }
            
            NavigationLink {
                CreateAccountView()
            } label: {
                Text("Create Account")
            }

        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
