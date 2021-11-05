//
//  LoginView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 09/10/2021.
//

import SwiftUI

extension LoginView {
    class ViewModel: ObservableObject {
        
        @Published var email: String = ""
        @Published var password: String = ""
        
        func signIn(){
            Task.init(priority: .userInitiated) {
                await AuthViewModel.shared.signIn(email: email, password: password)
            }
        }
    }
}

struct LoginView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: LoginView.ViewModel = LoginView.ViewModel()
    
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
                Text("Welcome Back")
                    .font(.system(size: 32, weight: .semibold))
            }
            .frame(height: 100, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            CustomTextField(text: "Email", placeholder: "E.g. john.smith@mail.com", binding: $viewModel.email)
            
            CustomTextField(text: "Password", placeholder: "Min 6 characters", binding: $viewModel.password, isSecure: true)
            
            Button {
                viewModel.signIn()
            } label: {
                Text("Login")
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
                Text("Don't have an account yet?")
                    .font(.system(size: 15, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                NavigationLink {
                    CreateAccountView()
                } label: {
                    Text("Create Account")
                        .font(.system(size: 17, weight: .bold))
                }
                .isDetailLink(true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


struct CustomTextField: View {
    
    let text: String
    let placeholder: String
    @Binding var binding: String
    @State var isSecure: Bool = false
    
    @State private var isActive: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(text)
                .font(.system(size: 17, weight: .regular))
            
            ZStack {
                
                if !isSecure {
                    TextField(placeholder, text: $binding)
                }else{
                    SecureField(placeholder, text: $binding)
                }
            }
            .frame(height: 20)
            .padding()
            .tint(Color.theme.accent)
            .background(Color.onboarding.textfield)
            .cornerRadius(5)
            
            .overlay(
                VStack {
                    if isSecure || isActive {
                        
                        Button(action: {
                            isActive.toggle()
                            isSecure.toggle()
                        }, label: {
                            Image(systemName: isActive ? "eye.slash" : "eye")
                                .padding(5)
                                .foregroundColor(Color.theme.accent)
                        })
                            .padding(.horizontal, 10)
                    }
                }
                ,alignment: .trailing
            )
        }
    }
}
