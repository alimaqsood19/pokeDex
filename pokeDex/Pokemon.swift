//
//  Pokemon.swift
//  pokeDex
//
//  Created by Ambar Maqsood on 2016-10-05.
//  Copyright © 2016 Ambar Maqsood. All rights reserved.
//

import Foundation
import Alamofire


class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokeDexID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonURL: String!
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionID: String {
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
          return _nextEvolutionText
        }
    
    
    var name: String {
        return _name
    }
    
    var pokeDexID: Int {
        return _pokeDexID
    }
    
    init(name: String, pokeDexID: Int) {
        
        self._name = name
        self._pokeDexID = pokeDexID
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokeDexID)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int{
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                }else {
                    self._type = ""
                }
                
                if let descripArray = dict["descriptions"] as? [Dictionary<String, String>] , descripArray.count > 0 {
                    if let url = descripArray[0]["resource_uri"] {
                        
                        let descripURL = "\(URL_BASE)\(url)"
                        Alamofire.request(descripURL).responseJSON(completionHandler: { (response) in
                            if let descripDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = descripDict["description"] as? String {
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    
                                    self._description = newDescription
                                    print(newDescription)
                                }
                            }
                            completed()
                        })
                    }
                }else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                    
                    if let nextEvo = evolutions[0]["to"] as? String {
                        
                        if nextEvo.range(of: "mega") == nil  {//only if its not a mega continue
                            
                            self._nextEvolutionName = nextEvo
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoID = newString.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionID = nextEvoID
                                
                                if let lvlExists = evolutions[0]["level"] {
                                    
                                    if let lvl = lvlExists as? Int {
                                        self._nextEvolutionLvl = "\(lvl)"
                                    }
                                    
                                }else {
                                    self._nextEvolutionLvl = ""
                                }
                            }
                            
                        }
                    }
                }
            }
            
            completed()
        }
        
        
    }
    
    

}
