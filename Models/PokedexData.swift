//
//  PokedexData.swift
//  Poké-Raider
//
//  Created by Steve Wall on 7/9/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore


class PokedexData {
    let db = Firestore.firestore()
    lazy var pokedexRef = db.collection("pokedex")
    static let shared = PokedexData()
    var pokedex: Pokedex = Pokedex(pokemonArray: [PokemonItem](), version: 0)
    var pokedexServerVersion: Int?
    var pokedexLocalVersion: Int?
    
    // Get new pokedex from the server
    func getPokedexFromServer() {
        db.collection("pokedex").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    // MARK: - TODO! Save the version of the pokedex in some kind of config. Bundle with other app settings somewhere.
                    // Also add a listener to the pokedex in server to update app in realtime with any changes automatically.
                    if id == "config" {
                        guard let version = document.data()["version"] as? Int else { return }
                        print("Pokedex Version: \(version)")
                        self.pokedex.version = version
                        continue
                    }
                    guard let docId = Int(id) else { print("error: docId"); return }
                    guard let name = document.data()["name"] as? String else { print("error: name"); return }
                    guard let number = document.data()["num"] as? String else { print("error: number"); return }
                    guard let type = document.data()["type"] as? [String] else { print("error: type"); return }
                    guard let weaknesses = document.data()["weaknesses"] as? [String] else { print("error: weaknesses"); return }
                    guard let image = document.data()["img"] as? String else { print("error: image"); return }
                    guard let egg = document.data()["egg"] as? String else { print("error: egg"); return }
                    
                    var pokemonItem = PokemonItem(isSelected: false, id: docId, name: name, numberString: number, imageUrl: image, type: type, weaknesses: weaknesses, egg: egg, candyCount: nil, previousEvolution: nil, nextEvolution: nil)
                    
                    if let candyCount = document.data()["candy_count"] as? Int {
                        pokemonItem.candyCount = candyCount
                    }
                    
                    if let previousEvolution = document.data()["prev_evolution"] as? [String : [String : String]] {
                        pokemonItem.previousEvolution = previousEvolution
                    }
                    
                    if let nextEvolution = document.data()["next_evolution"] as? [String : [String : String]] {
                        pokemonItem.nextEvolution = nextEvolution
                    }

                    self.pokedex.pokemonArray.append(pokemonItem)
                }
                self.pokedex.pokemonArray.sort(by: { $0.id < $1.id })
                
                DataManager.save(self.pokedex, with: "pokedex")
                
                print(print("SAVED POKEDEX ITEMS"))
            }
        }
    }
    
    func loadPokedexFromJSON() {
        pokedex = getLocalPokedexJSON()
    }
    
    func getLocalPokedexJSON() -> Pokedex {
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(Pokedex.self, from: DataManager.loadData("pokedex")!)
            print(type(of: decoded))
            print("getPokedexFromJSON")
            return decoded
        } catch {
            fatalError("PokdexJSON, No data to fetch")
        }
    }
    
    // Check to see if the current pokedex version is outdated. 
    func isOldPokedex() -> Bool {
        if let local = pokedexLocalVersion,
            let server = pokedexServerVersion {
            return local < server
        }
        return false
    }

    func getServerVersionOfPokedex() {
        let versionRef = db.collection("pokedex").document("config")
        versionRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                if let version = document.data()!["version"] {
                    self.pokedexServerVersion = version as? Int
                    print("pokedexServerVersion: \(String(describing: self.pokedexServerVersion))")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getLocalVersionOfPokedex() -> Int {
        return pokedex.version
    }
    
    func configure() {
        
    }
}

    

    

