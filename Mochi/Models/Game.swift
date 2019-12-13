//
//  Game.swift
//  Mochi
//
//  Created by Akshay Jain on 13/12/2019.
//  Copyright © 2019 Akshay Jain. All rights reserved.
//

import UIKit

class Game: NSObject {
    public var game_name : String?
    public var game_image_url : String?
    public var game_link_url : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let game = Game.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Game Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Game]
    {
        var models:[Game] = []
        for item in array
        {
            models.append(Game(dictionary: item as! [String: Any])!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let Game = Game(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Game Instance.
     */
    required public init?(dictionary: [String: Any]) {
        game_name = dictionary["game_name"] as? String
        game_image_url = dictionary["game_image_url"] as? String
        game_link_url = dictionary["game_link_url"] as? String
    }
}
