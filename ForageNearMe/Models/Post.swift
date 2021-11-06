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
import CoreLocation

struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    
    let name: String
    let imageURL: String
    
    var didLike: Bool?
    
    var notes: String
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    
    var location: GeoPoint
}
