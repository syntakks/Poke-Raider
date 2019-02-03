//
//  AppDelegate.swift
//  Poké-Raider
//
//  Created by Steve Wall on 6/25/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import GoogleToolboxForMac

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        FirebaseApp.configure()
    
        //let db = Firestore.firestore()
        //let pokedex = db.collection("pokedex")
        //var jsonArray: [JSON] = [JSON]()
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if DataManager.pokedexFileExists() {
            print("json loaded")
            PokedexData.shared.loadPokedexFromJSON()
            
        } else {
            print("json fetched")
            PokedexData.shared.getPokedexFromServer()
        }
        
        // MARK: - Fix whatever the hell is broken in the login. 
        if(isUserLoggedIn){
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mapViewController = mainStoryBoard.instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
            window?.rootViewController = mapViewController
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
}
    
    
    
    







    
    
    // MARK: - Update Firestore with local JSON file
    //                    if let path = Bundle.main.path(forResource: "pokedex", ofType: "json") {
    //                        do {
    //                            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    //                            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
    //                            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let pokemonList = jsonResult["pokemon"] as? [Any] {  //
    //                                // do stuff
    //                                print("JSON RESULT COUNT: \(pokemonList.count)")
    //                                for i in 0..<pokemonList.count {
    //                                    let pokemon = pokemonList[i] as! [String : Any]
    //                                    if let pokeID = pokemon["id"],
    //                                        let pokeName = pokemon["name"],
    //                                        let num = pokemon["num"],
    //                                        let img = pokemon["img"],
    //                                        let weaknesses = pokemon["weaknesses"],
    //                                        let type = pokemon["type"],
    //                                        let egg = pokemon["egg"] {
    //
    //                                        pokedex.document("\(pokeID)").updateData([
    //                                            "name" : pokeName,
    //                                            "num" : num,
    //                                            "img" : img,
    //                                            "weaknesses" : weaknesses,
    //                                            "type" : type,
    //                                            "egg" : egg
    //                                            ])
    //
    //                                        if let previous = pokemon["prev_evolution"] {
    //                                            pokedex.document("\(pokeID)").updateData([
    //                                                "prev_evolution" : previous
    //                                                ])
    //                                        }
    //
    //
    //                                        if let next = pokemon["next_evolution"] {
    //                                            pokedex.document("\(pokeID)").updateData([
    //                                                "next_evolution" : next
    //                                                ])
    //                                        }
    //
    //                                        if let candyCount = pokemon["candy_count"] {
    //                                            pokedex.document("\(pokeID)").updateData([
    //                                                "candy_count" : candyCount
    //                                                ])
    //                                        }
    //
    //                                        print(pokeID)
    //                                        print(pokeName)
    //                                    }
    //                                }
    //                            }
    //
    //                        } catch {
    //                            // handle error
    //                        }
    //                    }


