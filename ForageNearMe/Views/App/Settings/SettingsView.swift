//
//  SettingsView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 26/10/2021.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @Environment(\.dismiss) var dismiss
    
    @State var confirmationShown: Bool = false
    
    @State var isShareSheetVisible: Bool = false
    
    @State var isSigningOut: Bool = false
    
    func shareButton() {
        guard let url = URL(string: "https://apps.apple.com/gb/app/iforage/id1592190038") else { return }
            let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        UIApplication
        .shared
        .connectedScenes
        .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
        .first { $0.isKeyWindow }?.rootViewController?.present(activityController, animated: true, completion: nil)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(spacing: 20) {
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .font(.system(size: 18, weight: .semibold))
                        .scaledToFit()
                        .frame(width: 21, height: 21)
                }
                .foregroundColor(Color.theme.accent)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(Color.theme.navigationBackground)
            
            VStack(alignment: .leading, spacing: 30) {
                
                HStack(spacing: 10) {
                    Image(systemName: "circle.righthalf.fill")
                    Text("Dark mode")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(isDarkMode ? "On" : "Off")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.gray)
                    Toggle(isOn: $isDarkMode) {
                        Text("")
                    }
                    .frame(width: 50)
                }
                .foregroundColor(Color.theme.accent)
                .font(.system(size: 23, weight: .semibold))
                
                Button {
                    guard let url = URL(string: "https://apps.apple.com/app/iforage/id1592190038") else { return }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } label: {
                    
                        HStack(spacing: 10) {
                            Image(systemName: "hand.thumbsup.circle.fill")
                            Text("Rate Us")
                        }
                        .foregroundColor(Color.theme.accent)
                        .font(.system(size: 23, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button {
                    shareButton()
                } label: {
                    
                        HStack(spacing: 10) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                        .foregroundColor(Color.theme.accent)
                        .font(.system(size: 23, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                
                Button {
                    isSigningOut = true
                    confirmationShown = true
                } label: {
                
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.left.square.fill")
                        Text("Sign Out")
                    }
                    .foregroundColor(Color.theme.accent)
                    .font(.system(size: 23, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Button {
                    isSigningOut = false
                    confirmationShown = true
                } label: {
                
                    HStack(spacing: 10) {
                        Image(systemName: "xmark.bin")
                        Text("Delete Account")
                    }
                    .foregroundColor(Color.theme.accent)
                    .font(.system(size: 23, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.theme.background)
        .navigationBarHidden(true)
        .navigationTitle("")
        .confirmationDialog("Are you sure?", isPresented: $confirmationShown, titleVisibility: .visible) {
            Button("Yes") {
                if isSigningOut {
                    AuthViewModel.shared.signOut()
                }else{
                    Task.init(priority: .userInitiated) {
                        await AuthViewModel.shared.deleteUser()
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}
