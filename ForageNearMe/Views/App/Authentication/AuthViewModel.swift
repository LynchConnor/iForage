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
    
    func signIn(email: String, password: String) async {
        do {
            let (result) = try await Auth.auth().signIn(withEmail: email, password: password)
            let id = result.user.uid
            
            DispatchQueue.main.async {
                self.currentUserId = id
                self.authStatus = .signedIn
            }
        }catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    func createAccount(email: String, password: String) async {
        do {
            let (result) = try await Auth.auth().createUser(withEmail: email, password: password)
            let id = result.user.uid
            
            try await COLLECTION_USERS.document(id).setData([:])
            
            DispatchQueue.main.async {
                self.currentUserId = id
                self.authStatus = .signedIn
            }
        }catch {print("DEBUG: \(error.localizedDescription)")}
    }
    
    func deleteUser() async {
        do { try await Auth.auth().currentUser?.delete() }
        catch { print("DEBUG: \(error.localizedDescription)") }
    }
    
    func signOut(){
        try? Auth.auth().signOut()
        self.currentUserId = nil
        self.authStatus = .signedOut
    }
    
    func resetPassword(withEmail email: String) async {
        do { try await Auth.auth().sendPasswordReset(withEmail: email) }
        catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
}
