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
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    //initiates login process, call completion block with a user or an error depending on if it success or fails
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token!")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        //Twitter home timeline
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Error getting home timeline")
                completion(tweets: nil, error: error)
        })
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            //verify credentials
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                
                //persist user as current user
                User.currentUser = user
                print("User: \(user.name!)")
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("Error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            }) { (error: NSError!) -> Void in
                print("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
                
        }

    }
}
