//
//  ImageUploader.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 16/10/2021.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

struct ImageUploader {
    
    static func uploadImage(image: UIImage, completion: @escaping (String) -> Void){
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/post_images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                guard let imageURL = url?.absoluteString else { return }
                
                completion(imageURL)
            }
            
        }
    }
    
}
