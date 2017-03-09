//
//  ViewController.swift
//  Buddy Up
//
//  Created by Kyle Phan on 3/8/17.
//  Copyright © 2017 Kyle Phan. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AWSMobileHubHelper

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton : FBSDKLoginButton = FBSDKLoginButton()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleLoginWithSignInProvider(signInProvider: AWSSignInProvider) {
        AWSIdentityManager.default().login(signInProvider: signInProvider, completionHandler:
            {(result: Any?, error: Error?) -> Void in
                if error == nil {
                    /* Handle successful login. */
                }
                print("Login with signin provider result = \(result), error = \(error)")
        })
    }
    func handleFacebookLogin() {
        // Facebook login permissions can be optionally set, but must be set
        // before user authenticates.
        AWSFacebookSignInProvider.sharedInstance().setPermissions(["public_profile"]);
        
        handleLoginWithSignInProvider(signInProvider: AWSFacebookSignInProvider.sharedInstance())
    }
}

