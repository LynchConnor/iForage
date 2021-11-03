//
//  ContentView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 06/10/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var animationActive: Bool = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            
            VStack {
            
                switch authViewModel.authStatus {
                case .signedIn:
                    MainTabBarView()
                        .environmentObject(LocationManager.shared)
                case .signedOut:
                    OnboardingView()
                case .none:
                    ProgressView()
                }
            }
            .opacity(animationActive ? 1 : 0)
            
            
            SplashScreen(animationActive: $animationActive)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    animationActive.toggle()
                }
            }
        }
    }
}


struct SplashScreen: View {
    
    @Binding var animationActive: Bool
    
    var body: some View {
        
        Color.theme.background
            .mask {
                Rectangle()
                    .overlay(
                    
                    Image("logo-ai")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .scaleEffect(animationActive ? 10 : 1, anchor: .center)
                        .blendMode(.destinationOut)
                )
            }
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
