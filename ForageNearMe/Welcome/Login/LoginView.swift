//
//  LoginView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 08/10/2021.
//

import SwiftUI

struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            
            Text("Sign In")
                .font(.system(size: 34, weight: .semibold))
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                TextField("2", text: $email)
                Rectangle()
                    .frame(height: 0.75)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading) {
                Text("Password")
                SecureField("2", text: $password)
                Rectangle()
                    .frame(height: 0.75)
                    .foregroundColor(.gray)
            }
            
            Button {
                //
            } label: {
                Text("Forgot password?")
            }

            
            Button {
                //
            } label: {
                Text("Login")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
            }
            .cornerRadius(25)
            
            Text("Don't have an account? Register here")
                .frame(maxWidth: .infinity, alignment: .center)

        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
