//
//  CreateAccountView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 15/10/2021.
//

import SwiftUI

extension CreateAccountView {
    class ViewModel: ObservableObject {
        
        @Published var email: String = ""
        @Published var password: String = ""
        
        func createAccount(){
            AuthViewModel.shared.createAccount(email: email, password: password) {
                //
            }
        }
    }
}

struct CreateAccountView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: CreateAccountView.ViewModel = CreateAccountView.ViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            
            HStack {
                
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
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading) {
                Text("Create Account")
                    .font(.system(size: 32, weight: .semibold))
            }
            .frame(height: 100, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            CustomTextField(text: "Email", placeholder: "E.g. john.smith@mail.com", binding: $viewModel.email)
            
            CustomTextField(text: "Password", placeholder: "Min 6 characters", binding: $viewModel.password, isSecure: true)
            
            Button {
                viewModel.createAccount()
            } label: {
                Text("Create Account")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.init(red: 0/255, green: 157/255, blue: 190/255))
                    .cornerRadius(5)
            }
            .padding(.top, 10)
            
            Spacer()
            
            HStack(spacing: 0) {
                Text("Already have an account?")
                    .font(.system(size: 15, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                NavigationLink {
                    LoginView()
                } label: {
                    Text("Log In")
                        .font(.system(size: 17, weight: .bold))
                }
            }
            .foregroundColor(Color.theme.accent)
            
        }
        
        .navigationBarHidden(true)
        .navigationBarTitle("")
        
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .background(Color.theme.background)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateAccountView()
        }
    }
}
