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
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}
