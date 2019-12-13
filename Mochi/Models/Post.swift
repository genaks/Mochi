//
//  Post.swift
//  Mochi
//
//  Created by Akshay Jain on 11/12/2019.
//  Copyright © 2019 Akshay Jain. All rights reserved.
//

import UIKit

class Post: NSObject {
    public var post_id : Int?
    public var captionText : String?
    public var like_count : Int?
    public var view_count : Int?
    public var liked : Bool?
    public var video_url : URL!
    public var game : Game?
    public var user : User?
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let feed = Post.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Post Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Post]
    {
        var models:[Post] = []
        for item in array
        {
            models.append(Post(dictionary: item as! [String: Any])!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let post = Post(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Post Instance.
     */
    required public init?(dictionary: [String: Any]) {
        
        post_id = dictionary["post_id"] as? Int
        captionText = dictionary["captionText"] as? String
        like_count = dictionary["like_count"] as? Int
        view_count = dictionary["view_count"] as? Int
        liked = dictionary["liked"] as? Bool
        video_url = URL(string: (dictionary["video_url"] as! String))
        if let game_object = dictionary["game"] as? [String : Any] {
            game = Game(dictionary: game_object)
        }
        if let user_object = dictionary["user"] as? [String : Any] {
            user = User(dictionary: user_object)
        }
    }
}
