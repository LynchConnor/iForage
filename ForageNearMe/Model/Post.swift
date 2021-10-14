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

struct Post: Identifiable, Decodable {
    @DocumentID var id: String?
    
    var latinName: String?
    let name: String
    let imageURL: String
    
    var isLiked: Bool?
    
    let notes: String
    
    let location: GeoPoint
}
