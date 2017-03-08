//
//  ViewController.swift
//  Buddy Up
//
//  Created by Kyle Phan on 3/8/17.
//  Copyright © 2017 Kyle Phan. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {
    let Loginbutton : FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(Loginbutton)
        Loginbutton.center = view.center
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

