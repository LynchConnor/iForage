//
//  MainTabBarView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 11/10/2021.
//

import SwiftUI

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.9 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

struct LikeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.9 : 1)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}

struct MainTabBarView: View {
    
    // - Public
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        if locationManager.lastLocation != nil {
            ZStack {
                
                HomeView()
                    .environmentObject(locationManager)
                
            }
            .background(Color.blue)
        }
        else{
            VStack(spacing: 25) {
                Text("To access the map you need to enable location services.")
                    .font(.system(size: 22, weight: .bold))
                    .multilineTextAlignment(.center)
                HStack {
                    Button {
                        locationManager.requestAuthorization()
                        locationManager.requestLocation()
                    } label: {
                        Text("Enable location")
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(Color.onboarding.buttonBackground)
                    .cornerRadius(20)
                    
                    Text("☜(ˆ▿ˆc)")
                        .font(.system(size: 32, weight: .heavy))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct MainTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarView()
    }
}
