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
            TabView {
                HomeView()
                    .environmentObject(locationManager)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                CreatePostView()
                    .environmentObject(locationManager)
                    .tabItem {
                        Label("Create", systemImage: "plus.square")
                    }
                FavouriteView()
                    .tabItem {
                        Label("My Finds", systemImage: "heart")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }

            }
        }
    }
}

struct MainTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarView()
    }
}
