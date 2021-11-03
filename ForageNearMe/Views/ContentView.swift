//
//  ContentView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 06/10/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var splashScreenActive: Bool = false
    
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
        }
        .overlay(
            
            
            SplashScreen(isActive: $splashScreenActive, content: {
                Image("logo")
                    .resizable()
                    .renderingMode(.template)
            }, background: {
                Color.theme.cardBackground
            })
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.6)) {
                    splashScreenActive = true
                }
            }
        }
    }
}

struct SplashScreen<Content: View, Background: View>: View {
    
    @Binding var isActive: Bool
    
    private var content: () -> (Content)
    private var background: () -> (Background)
    
    init(isActive: Binding<Bool>,
         @ViewBuilder content: @escaping () -> Content,
         @ViewBuilder background: @escaping () -> Background){
        self._isActive = isActive
        self.content = content
        self.background = background
    }
    
    var body: some View {
        ZStack {
            
            background()
                .mask({
                    Rectangle()
                        .overlay(
                            
                            ZStack {

                                content()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200, alignment: .center)
                                        .foregroundColor(.white)
                                        .blendMode(.destinationOut)
                                        .scaleEffect(isActive ? 20 : 1, anchor: .center)
                    
                                
                            }
                        )
                })
                .overlay(
                    
                    content()
                        .scaledToFit()
                        .frame(width: 200, height: 200, alignment: .center)
                            .foregroundColor(.white)
                        .scaleEffect(isActive ? 20 : 1, anchor: .center)
                        .opacity(isActive ? 0 : 1)
                )
                .opacity(isActive ? 0 : 1)
                .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
