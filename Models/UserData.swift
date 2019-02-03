//
//  UserData.swift
//  Poké-Raider
//
//  Created by Steve Wall on 7/2/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import Foundation
import Firebase
import MapKit

class UserData {
    
    var ref: DatabaseReference = Database.database().reference()
    
    let kUid = "uID"
    let kUsername = "username"
    let kIsUserLoggedIn = "isUserLoggedIn"
    let kUserLocation = "userLocation"
    let kUserLatitude = "userLatitude"
    let kUserLongitude = "userLongitude"
    
    var user: User?
    
    static let shared = UserData()
    
    func values() -> [String : Any]? {
        if let user = user {
                return [
                    "username" : user.username,
                    "isUserLoggedIn" : user.isUserLoggedIn,
                    "latitude" : user.latitude,
                    "longitude" : user.longitude
                ]
        }
        return nil
    }
    
    func syncronize() {
        let userDefaults = UserDefaults.standard
        if let user = user {
            userDefaults.set(user.uID, forKey: kUid)
            userDefaults.set(user.username, forKey: kUsername)
            userDefaults.set(user.isUserLoggedIn, forKey: kIsUserLoggedIn)
            userDefaults.set(user.latitude, forKey: kUserLatitude)
            userDefaults.set(user.longitude, forKey: kUserLongitude)
            userDefaults.synchronize()
            ref.child("users").child(user.uID).setValue(self.values())
        }
    }
    
    func updateUsername(with username: String) {
        user?.username = username
        syncronize()
    }
    
    func updateIsUserLoggedIn(_ isLoggedIn: Bool) {
        user?.isUserLoggedIn = isLoggedIn
        syncronize()
    }
    
    func updateUserLocation(_ location: CLLocation) {
        user?.userLocation = location
        syncronize()
    }
    
}
