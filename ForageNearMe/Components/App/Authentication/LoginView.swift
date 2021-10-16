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
            AuthViewModel.shared.signIn(email: email, password: password) {
                //
            }
        }
    }
}

struct LoginView: View {
    
    @StateObject var viewModel: LoginView.ViewModel = LoginView.ViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
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
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        
        .navigationBarHidden(true)
        .navigationBarTitle("")
        
        .padding(.horizontal, 20)
        .padding(.top, 50)
        
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    
    private struct CustomTextField: View {
        
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
                .background(Color.init(red: 247/255, green: 247/255, blue: 247/255))
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
                                    .foregroundColor(.black)
                            })
                                .padding(.horizontal, 10)
                        }
                    }
                    ,alignment: .trailing
                )
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
