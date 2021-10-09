//
//  RegisterView.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 08/10/2021.
//

import SwiftUI

struct RegisterView: View {

    @State var displayName: String = ""
    @State var emailAddress: String = ""
    @State var password: String = ""
    
    @State var isFocused: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Create your account")
                    .font(.system(size: 42, weight: .semibold))
                
                Text("Sign up to continue")
            }
            .frame(maxHeight: .infinity)
            
            VStack(spacing: 20) {
                
                RegisterViewTextField(binding: $displayName, heading: "In-App Name", text: "Any name you want", icon: "person.fill")
                
                RegisterViewTextField(binding: $emailAddress, heading: "Email Address", text: "youremail@example.com", icon: "envelope.fill")
                
                RegisterViewTextField(binding: $password, heading: "Enter a password", text: "At least 6 characters", icon: "lock.fill", isSecure: true)
                
                Button {
                    //
                } label: {
                    Text("Create my account")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 25, alignment: .center)
                        .padding()
                        .background(Color.green)
                }
                .cornerRadius(25)
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 25)
        .padding(.vertical, 50)
        .background(Color.init(red: 239/255, green: 240/255, blue: 243/255))
        .edgesIgnoringSafeArea(.all)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

struct RegisterViewTextField: View {
    
    @Binding var binding: String
    let heading: String
    let text: String
    let icon: String
    @State var isSecure: Bool = false
    
    @State var isVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(heading)
                .offset(x: 15)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                
                if !isSecure || isVisible {
                    
                    TextField(text, text: $binding)
                        .frame(maxWidth: .infinity, maxHeight: 25, alignment: .leading)
                    
                }else{
                    SecureField(text, text: $binding)
                        .frame(maxWidth: .infinity, maxHeight: 25, alignment: .leading)
                }
            }
            .padding(.horizontal, 6)
            .overlay(
                ZStack {
                    if isSecure && binding.count > 0 {
                        Image(systemName: isVisible ? "eye" : "eye.slash")
                            .onTapGesture {
                                withAnimation {
                                    isVisible.toggle()
                                }
                            }
                    }
                }
                ,alignment: .trailing
            )
            .padding(15)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 1.75)
            )
        }
    }
}
