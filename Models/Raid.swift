//
//  Raid.swift
//  Poké-Raider
//
//  Created by Steve Wall on 7/3/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import Foundation
import MapKit

enum RaidStatus {
    case egg
    case hatched
}

class Raid {
    var latitude: Double
    var longitude: Double
    var location: CLLocation
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        location = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    init(at location: CLLocation) {
        self.location = location
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
    
    func values() -> [String : Any] {
        return [
            "latitude" : latitude,
            "longitude" : longitude
        ]
    }
    
//    var status: RaidStatus
//    var level: Int // 1-5
//    var pokemonName: String?
//    var pokemonCP: Int?
//    var numberOfRaiders: Int?
//    var raiders: [Raider]?
    // Need something to handle the hatch time.
    // Also need to handle the removal of the pins using Cloud Functions 
    
}
