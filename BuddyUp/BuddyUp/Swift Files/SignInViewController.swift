//
//  ViewController.swift
//  BuddyUp
//
//  Created by Kyle Phan on 3/9/17.
//  Copyright © 2017 Kyle Phan. All rights reserved.
//

import UIKit
import AWSMobileHubHelper
import FBSDKLoginKit
import FBSDKCoreKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton:UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    
    var didSignInObserver: AnyObject!
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AnyObject>?

    @IBOutlet weak var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        didSignInObserver =  NotificationCenter.default.addObserver(forName: NSNotification.Name.AWSIdentityManagerDidSignIn,
                                                                    object: AWSIdentityManager.default(),
                                                                    queue: OperationQueue.main,
                                                                    using: {(note: Notification) -> Void in
                                                                        // perform successful login actions here
        })
        
        // Facebook login permissions can be optionally set, but must be set
        // before user authenticates.
        AWSFacebookSignInProvider.sharedInstance().setPermissions(["public_profile"]);
        
        // Facebook login behavior can be optionally set, but must be set
        // before user authenticates.
        //                AWSFacebookSignInProvider.sharedInstance().setLoginBehavior(FBSDKLoginBehavior.Web.rawValue)
        
        // Facebook UI Setup
        facebookButton.addTarget(self, action: #selector(SignInViewController.handleFacebookLogin), for: .touchUpInside)
        let facebookButtonImage: UIImage? = UIImage(named: "FacebookButton")
        if let facebookButtonImage = facebookButtonImage{
            facebookButton.setImage(facebookButtonImage, for: UIControlState())
        } else {
            print("Facebook button image unavailable. We're hiding this button.")
            facebookButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility Methods
    
    func handleLoginWithSignInProvider(_ signInProvider: AWSSignInProvider) {
        AWSIdentityManager.default().login(signInProvider: signInProvider, completionHandler:
            {(result: Any?, error: Error?) -> Void in
                if error == nil {
                    /* Handle successful login. */
                    
                }
                print("Login with signin provider result = \(result), error = \(error)")
        })
    }


    // MARK: - IBActions
    func handleFacebookLogin() {
        AWSFacebookSignInProvider.sharedInstance().setPermissions(["public_profile"]);
        handleLoginWithSignInProvider(AWSFacebookSignInProvider.sharedInstance())
    }
    
}

