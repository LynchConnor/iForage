//
//  AuthViewModel.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 15/10/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

enum AuthStatus {
    case signedIn
    case signedOut
}

class AuthViewModel: ObservableObject {
    
    @Published var authStatus: AuthStatus?
    
    @Published var currentUserId: String?
    
    static var shared = AuthViewModel()
    
    init(){
        if isUserSignedIn {
            authStatus = .signedIn
            guard let id = Auth.auth().currentUser?.uid else { return }
            self.currentUserId = id
        }else{
            authStatus = .signedOut
        }
    }
    
    private var isUserSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func signIn(email: String, password: String, completion: @escaping () -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { dataResult, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            
            guard let id = dataResult?.user.uid else { return }
            self.currentUserId = id
            self.authStatus = .signedIn
        }
    }
    
    func createAccount(email: String, password: String, completion: @escaping () -> ()){
        print("DEBUG: Password \(password)")
        Auth.auth().createUser(withEmail: email, password: password) { dataResult, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            
            guard let id = dataResult?.user.uid else { return }
            
            COLLECTION_USERS.document(id).setData([:]) { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                self.currentUserId = id
                self.authStatus = .signedIn
            }
        }
    }
    
    func signOut(){
        try? Auth.auth().signOut()
        self.currentUserId = nil
        self.authStatus = .signedOut
    }
    
}
