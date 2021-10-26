//
//  SettingsView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 26/10/2021.
//

import SwiftUI

struct SettingsView: View {
    
    @State var confirmationShown: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            Button {
                confirmationShown = true
            } label: {
            
                HStack(spacing: 5) {
                    Image(systemName: "arrow.left.square.fill")
                    Text("Sign Out")
                }
                .foregroundColor(.black)
                .font(.system(size: 23, weight: .semibold))
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
