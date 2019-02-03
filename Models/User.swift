//
//  User.swift
//  Poké-Raider
//
//  Created by Steve Wall on 7/2/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import Foundation
import MapKit

class User {
    var uID: String
    var username: String
    var isUserLoggedIn: Bool
    var userLocation: CLLocation?
    var latitude: Double
    var longitude: Double
    
    init(uID: String?, username: String?, isUserLoggedIn: Bool?, userLocation: CLLocation?) {
        self.uID = uID ?? ""
        self.username = username ?? ""
        self.isUserLoggedIn = isUserLoggedIn ?? false
        self.userLocation = userLocation ?? CLLocation(latitude: 45, longitude: 90)
        self.latitude = 45
        self.longitude = 90
    }
}

