//
//  PokemonItem.swift
//  Poké-Raider
//
//  Created by Steve Wall on 7/9/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import Foundation

struct PokemonItem: Codable {
    var isSelected: Bool = false
    var id: Int
    var name: String
    var numberString: String
    var imageUrl: String
    var type: [String]
    var weaknesses: [String]
    var egg: String
    var candyCount: Int?
    var previousEvolution: [String : [String : String]]?
    var nextEvolution: [String : [String : String]]?
    
    enum CodingKeys : String, CodingKey {
        case isSelected = "isSelected"
        case id = "id"
        case name
        case numberString
        case imageUrl
        case type = "type"
        case weaknesses = "weaknesses"
        case egg
        case candyCount = "candyCount"
        case previousEvolution = "previousEvolution"
        case nextEvolution = "nextEvolution"
    }
    
    func saveItem() {
        DataManager.save(self, with: String(id))
    }
    
    func deleteItem() {
        DataManager.delete(String(id))
    }
}
