//
//  Pokemon.swift
//  pokedex
//
//  Created by Jeremy Zang on 3/27/17.
//  Copyright © 2017 Jeremy Zang. All rights reserved.
//

import Foundation

class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
    
    
    
    
    
    
}
