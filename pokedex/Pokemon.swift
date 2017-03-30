//
//  Pokemon.swift
//  pokedex
//
//  Created by Jeremy Zang on 3/27/17.
//  Copyright © 2017 Jeremy Zang. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _pokemonURL: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            return ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            return ""
        }
        return _nextEvolutionLvl
    }

    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            return ""
        }
        return _nextEvolutionName
    }
    
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            return ""
        }
        return _description
    }
    
    var type: String {
        return _type
    }
    
    var defense: String {
        return _defense
    }
    
    var height: String {
        return _height
    }
    
    var weight: String {
        return _weight
    }
    
    var attack: String {
        return _attack
    }
    
    var nextEvolution: String {
        
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId!)/"
        
    }
    
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete){
        print(_pokemonURL)
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            let result = response.result
            if let dictionary = result.value as? Dictionary<String, AnyObject> {
                if let attack = dictionary["attack"] as? Int {
                    self._attack = String(attack)
                }
                if let defense = dictionary["defense"] as? Int {
                    self._defense = String(defense)
                }
                if let pokedexID = dictionary["pkdx_id"] as? Int {
                    self._pokedexId = pokedexID
                }
                
                if let weight = dictionary["weight"] as? String {
                    self._weight = weight
                }
                if let height = dictionary["height"] as? String {
                    self._height = height
                }
                if let types = dictionary["types"] as? [Dictionary<String, AnyObject>] , types.count > 0 {
                    if let name = types[0]["name"]{
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized!)"
                            }
                        }
                    }

                } else {
                    self._type = ""
                }
                
                if let descriptionArr = dictionary["descriptions"] as? [Dictionary<String, String>] , descriptionArr.count > 0 {
                    if let url = descriptionArr[0]["resource_uri"] {
                        let descriptionurl = "\(URL_BASE)\(url)"
                        print(descriptionurl)
                        Alamofire.request(descriptionurl).responseJSON(completionHandler: { (response) in
                            if let descriptionDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = descriptionDict["description"] as? String {
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDescription
                                    print(newDescription)
                                }
                            }
                            completed()
                        })
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dictionary["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                    
                    if let nextEvo = evolutions[0]["to"] as? String {
                        
                        if nextEvo.range(of: "mega") == nil {
                            
                            self._nextEvolutionName = nextEvo
                            
                            print("NextEvolutionName: " + self._nextEvolutionName)
                            
                            if let nextEvoURL = evolutions[0]["resource_uri"] as? String {
                                
                                let newString = nextEvoURL.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newString.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvoId
                                
                                print("NextEvolutionId: " + self._nextEvolutionId)
                                
                                if let lvlExists = evolutions[0]["level"] {
                                    if let nextEvoLvl = lvlExists as? Int {
                                        self._nextEvolutionLvl = String(nextEvoLvl)
                                        print("NextEvolutionLevel: " + self._nextEvolutionLvl)
                                    }
                                } else {
                                    self._nextEvolutionLvl = ""
                                }
                            }
                        }
                    }
                }
                    
//                print("NextEvolutionName: " + self._nextEvolutionName)
//                print("NextEvolutionId: " + self._nextEvolutionId)
//                print("NextEvolutionLevel: " + self._nextEvolutionLvl)
//                print("NextEvolutionText: " + self._nextEvolutionTxt)
                
                print("Attack: " + self._attack)
                print("Defense: " + self._defense)
                print("Weight: " + self._weight)
                print("Height: " + self._height)
                print("PokeDex ID: " + String(self._pokedexId))
                print("Types: " + self._type)
//                print("Description: " + self._description)
                
            }
            completed()
        }
    }
}
