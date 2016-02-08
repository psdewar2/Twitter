//
//  TwitterClient.swift
//  Twitter
//
//  Created by Peyt Spencer Dewar on 2/8/16.
//  Copyright © 2016 PSD. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "UhnuI0ytcAj82PrkDFZnhwpPx"
let twitterConsumerSecret = "z0IprqWb1kFrogrvlNtllO1XdaexmtexbUKNz1OLZeYQUNmkX4"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

//create a singleton to be accessed everywhere in the project
class TwitterClient: BDBOAuth1SessionManager {
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
}
