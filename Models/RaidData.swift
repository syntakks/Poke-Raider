//
//  RaidData.swift
//  Poké-Raider
//
//  Created by Steve Wall on 7/3/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import Foundation
import Firebase
import MapKit

struct MapRange {
    var minLat: CLLocationDegrees
    var maxLat: CLLocationDegrees
    var minLong: CLLocationDegrees
    var maxLong: CLLocationDegrees
}

class RaidData {
    let db = Firestore.firestore()
    lazy var raidStore = db.collection("raids")
    static let shared = RaidData()
    var myRaid: Raid?
    var mapRange: MapRange?
    
    func add(_ raid: Raid) {
        if let uID = UserDefaults.standard.string(forKey: "uID") {
            raidStore.document(uID).setData([
                "latitude" : raid.latitude,
                "longitude" : raid.longitude
                ])
        }
    }
    
    func removeRaid() {
        if let uID = UserDefaults.standard.string(forKey: "uID") {
            raidStore.document(uID).delete()
        }
    }
    
    // Search for raids within a range and limit the results. Future: handle pin filtering.
    
    func queryRaids() {
        guard let mapRange = mapRange else { return }
        print(mapRange)
    }
    
    
    // Get a specific raid by UID - Present more info about it.
    func getRaid(withUID: String) {
        
    }
    
}


