//
//  Pokedex.swift
//  Poké-Raider
//
//  Created by Steve Wall on 7/10/18.
//  Copyright © 2018 syntakks. All rights reserved.
//

import Foundation
import UIKit

struct Pokedex: Codable {
    var pokemonArray: [PokemonItem]
    var version: Int
}
