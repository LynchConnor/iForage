//
//  ForageNearMeApp.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 06/10/2021.
//

import SwiftUI
import Firebase

@main
struct ForageNearMeApp: App {
    
    init(){
        FirebaseApp.configure()
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(AuthViewModel.shared)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}
