//
//  User.swift
//  Mochi
//
//  Created by Akshay Jain on 13/12/2019.
//  Copyright © 2019 Akshay Jain. All rights reserved.
//

import UIKit

class User: NSObject {

    public var username : String?
    public var user_image_url : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let user = User.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of User Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [User]
    {
        var models:[User] = []
        for item in array
        {
            models.append(User(dictionary: item as! [String: Any])!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let user = User(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: User Instance.
     */
    required public init?(dictionary: [String: Any]) {
        username = dictionary["username"] as? String
        user_image_url = dictionary["user_image_url"] as? String
    }
}
