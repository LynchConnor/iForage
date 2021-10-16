//
//  ImageUploader.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 16/10/2021.
//

import Foundation
import SwiftUI
import FirebaseStorage

class ImageUploader {
    
    static func uploadImage(image: UIImage, completion: @escaping (String) -> ()){
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let URL = NSUUID().uuidString
        let ref = Storage.storage().reference(forURL: "/images/\(URL)")
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            
            print("DEBUG: Image Uploaded")
            
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
