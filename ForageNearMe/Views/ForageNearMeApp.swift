//
//  ForageNearMeApp.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 06/10/2021.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    print("Colors application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
    FirebaseApp.configure()
    return true
  }
}

@main
struct ForageNearMeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init(){
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
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
