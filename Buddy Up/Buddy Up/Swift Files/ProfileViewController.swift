//
//  ProfileViewController.swift
//  Buddy Up
//
//  Created by Kyle Phan on 3/29/17.
//  Copyright © 2017 Kyle Phan. All rights reserved.
//

import Foundation
import UIKit
import AWSMobileHubHelper

class ProfileViewController: UITabBarController{
    
    @IBOutlet weak var profileImage: UIImageView?
    @IBOutlet weak var username: UILabel?
    @IBOutlet weak var userID: UILabel?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let identityManager = AWSIdentityManager.default()
        self.username?.text = "Guest User"
        self.userID?.text = "Temporary"
    }
}
