//
//  User.swift
//  Twitter
//
//  Created by Peyt Spencer Dewar on 2/9/16.
//  Copyright © 2016 PSD. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "currentUserKey"
let userDidLoginNotification = "userDidLogin"
let userDidLogoutNotification = "userDidLogout"

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    //clears current user from global perspective
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    //this gives global notion of the current user at any time in the app
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    do {
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
                        _currentUser = User(dictionary: dictionary as! NSDictionary)
                    
                    }  catch let error as NSError {
                        //handle error
                        print("Error : \(error)")
                    }
                }
            }
            return _currentUser
        }
        set (user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions(rawValue: 0))
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                    NSUserDefaults.standardUserDefaults().synchronize()
                }   catch let error as NSError {
                    //handle error
                    print("Error : \(error)")
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
                    
                }
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
