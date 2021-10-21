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
    @StateObject var locationManager = LocationManager()
    
    @State var menuIsActive: Bool = false
    
    var body: some View {
        if locationManager.lastLocation != nil {
            ZStack {
//                SlideMenu(menuIsActive:  $menuIsActive)
                
                HomeView(menuIsActive: $menuIsActive)
                    .environmentObject(locationManager)
                    .offset(x: menuIsActive ? getRect().width - 120 : 0)
                    .scaleEffect(menuIsActive ? 0.84 : 1)
                    .disabled(menuIsActive)
            }
            .background(Color.blue)
        }
    }
}

struct MainTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarView()
    }
}

struct SlideMenu: View {
    
    @Binding var menuIsActive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            HStack {
                Text("iForage")
                    .foregroundColor(.white)
                    .font(.system(size: 32, weight: .semibold))
                Spacer()
                Button {
                    withAnimation {
                        menuIsActive.toggle()
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .scaledToFit()
                        .foregroundColor(.white)
                }
            }
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 35) {
                    
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Button {
                            withAnimation {
                                menuIsActive.toggle()
                            }
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "house")
                                Text("Home")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold))
                    }
                    
                    NavigationLink {
                        Text("ListView")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "list.bullet.rectangle")
                            Text("List")
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    NavigationLink {
                        Text("Favourite")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "heart")
                            Text("Favourites")
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    NavigationLink {
                        Text("SettingsView")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "arrow.left.square")
                            Text("Sign Out")
                        }
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.vertical, 50)
            }
            
        }
        
        .padding(.horizontal, 20)
        .padding(.vertical, 50)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .edgesIgnoringSafeArea(.all)
        .background(Color.blue)
    }
}
