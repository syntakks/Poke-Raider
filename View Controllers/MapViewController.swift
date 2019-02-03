//
//  ViewController.swift
//  mapTest
//
//  Created by Steve Wall on 6/22/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, GADBannerViewDelegate {
    
    //lazy var myRaidRef: DatabaseReference = Database.database().reference().child("raids").child(UserDefaults.standard.string(forKey: "uID")!)
    //lazy var raidsRef: DatabaseReference = Database.database().reference()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pokeBallButton: UIButton!
    @IBOutlet weak var filterPinsButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var editMapButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let kTestAdId = "ca-app-pub-3940256099942544/2934735716"
    let kMyBannerAdId = "ca-app-pub-1575881753613543/7618222106"
    
    var currentLocation: CLLocation?
    var myRaidLat: Double?
    var myRaidLong: Double?
    
    var swMapPoint: CLLocationCoordinate2D?
    var neMapPoint: CLLocationCoordinate2D?
    
    let locationManager = CLLocationManager()
    var willMoveToUserLocation: Bool = true
    let distanceSpan: CLLocationDistance = 1000 // This controls the map zoom in meters.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let loggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        print("isUserLoggedIn \(loggedIn)")
        
        // Setting up the banner ad
        self.bannerView.adUnitID = kTestAdId
        self.bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        
        
        // MARK: - Firebase Database Observer
        // My Raid Pin
//        myRaidRef.observe(.value) { snapshot in
//            print("Snapshot Children Count: \(snapshot.childrenCount)") // I got the expected number of items
//            print("Snapshot Key \(snapshot.key)")
//            print("Snapshot Value \(String(describing: snapshot.value))")
//        
//            if let data = snapshot.value as? [String:AnyObject] {
//                if let lat = data["lat"] as! Double?,
//                    let long = data["long"] as! Double? {
//                    print("data: Lat: \(lat) Long: \(long)")
//                }
//            }
//        }


        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {

    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateMapBounds() // Set the corners of the map.
    }
    
    fileprivate func goToApplicationSettings() {
        //string: UIApplication.openSettingsURLString
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                print("can open url")
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    func checkAuthorizationStatus() -> Bool {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            // Do not start services that aren't available.
            if !CLLocationManager.locationServicesEnabled() {
                // Location services is not available.
                return false
            }
            // Show an alert and direct the user to settings to turn location services on.
            print("Go to settings and turn on location settings.")
            let alertView = UIAlertController(title: "Location Disabled", message: "Please go to settings to enable location.", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { action in
                self.goToApplicationSettings()
            }
            alertView.addAction(cancelAction)
            alertView.addAction(settingsAction)
            present(alertView, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func currentLocationButtonPressed() {
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func updateMapBounds() {
        let mapRect = mapView.visibleMapRect
        // This is the bottom left Coordinate
        swMapPoint = getCoordinateFromMapRectanglePoint(x: mapRect.origin.x, y: mapRect.maxY)
        // This is the top right Coordinate
        neMapPoint = getCoordinateFromMapRectanglePoint(x: mapRect.maxX, y: mapRect.origin.y)
        if let swPoint = swMapPoint, let nePoint = neMapPoint {
            RaidData.shared.mapRange = MapRange(minLat: swPoint.latitude, maxLat: nePoint.latitude, minLong: swPoint.longitude, maxLong: nePoint.longitude)
            print("SOUTHWEST MAP POINT: \(swPoint)")
            print("NORTHEAST MAP POINT: \(nePoint)")
            print("")
        }
        
    }
    
    func getCoordinateFromMapRectanglePoint(x: Double, y: Double) -> CLLocationCoordinate2D {
        let mapPoint = MKMapPoint(x: x, y: y)
        return mapPoint.coordinate
    }
    
    // BANNER AD DELEGATE METHODS
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
}








//@IBAction func editMapButtonPressed(_ sender: Any) {
//    let alertView = UIAlertController(title: "Edit Map", message: nil, preferredStyle: .actionSheet)
//    // Add
//    let addPinAction = UIAlertAction(title: "Add Raid", style: .default) { action in
//        if let currentLocation = self.currentLocation {
//            let raid = Raid(at: currentLocation)
//            RaidData.shared.add(raid)
//        }
//    }
//    // Remove
//    let removePinAction = UIAlertAction(title: "Remove Raid", style: .destructive) { action in
//        RaidData.shared.removeRaid()
//    }
//    // Cancel
//    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//    alertView.addAction(addPinAction)
//    alertView.addAction(removePinAction)
//    alertView.addAction(cancelAction)
//
//    print("Pin Lat: \(String(describing: currentLocation?.coordinate.latitude)) Pin Long: \(String(describing: currentLocation?.coordinate.longitude))")
//    present(alertView, animated: true, completion: nil)
//}

