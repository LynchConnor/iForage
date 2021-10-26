//
//  SettingsView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 26/10/2021.
//

import SwiftUI

struct SettingsView: View {
    
    @State var darkModeActive: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    @State var confirmationShown: Bool = false
    
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
                .foregroundColor(Color.black.opacity(0.75))
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(Color.white)
            
            VStack(alignment: .leading, spacing: 40) {
                
//                HStack(spacing: 10) {
//                    Image(systemName: "circle.righthalf.fill")
//                    Text("Dark mode")
//                        .frame(maxWidth: .infinity, alignment: .leading)
//
//                    Text(darkModeActive ? "On" : "Off")
//                        .font(.system(size: 15, weight: .bold))
//                        .foregroundColor(.gray)
//                    Toggle(isOn: $darkModeActive) {
//                        Text("")
//                    }
//                    .frame(width: 50)
//                }
//                .foregroundColor(.black)
//                .font(.system(size: 23, weight: .semibold))
                
                Button {
                    confirmationShown = true
                } label: {
                
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.left.square.fill")
                        Text("Sign Out")
                    }
                    .foregroundColor(.black)
                    .font(.system(size: 23, weight: .semibold))
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationBarHidden(true)
        .navigationTitle("")
        .confirmationDialog("Are you sure?", isPresented: $confirmationShown, titleVisibility: .visible) {
            Button("Yes") {
                AuthViewModel.shared.signOut()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
