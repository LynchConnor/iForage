//
//  MainTabBarView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 11/10/2021.
//

import SwiftUI

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
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        if locationManager.lastLocation != nil {
            HomeView()
                .environmentObject(locationManager)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
        }
    }
}

struct MainTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarView()
    }
}
