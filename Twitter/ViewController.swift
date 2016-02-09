//
//  ViewController.swift
//  Twitter
//
//  Created by Peyt Spencer Dewar on 2/7/16.
//  Copyright © 2016 PSD. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {( user: User?, error: NSError?) in
            if user != nil {
                //perform segue
                self.performSegueWithIdentifier("loginSegue", sender: sender)
            } else {
                //handle login error
            }
        }
        
    }

}

