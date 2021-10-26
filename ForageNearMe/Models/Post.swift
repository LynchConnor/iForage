//
//  Post.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 10/10/2021.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    
    let name: String
    let imageURL: String
    
    var didLike: Bool?
    
    var notes: String
    
    var location: GeoPoint
}
