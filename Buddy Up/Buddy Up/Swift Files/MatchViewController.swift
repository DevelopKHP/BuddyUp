//
//  MatchViewController.swift
//  Buddy Up
//
//  Created by Kyle Phan on 4/28/17.
//  Copyright © 2017 Kyle Phan. All rights reserved.
//

import Foundation
import UIKit
import AWSMobileHubHelper
import AWSDynamoDB

class MatchViewController: UIViewController {
    
    var willEnterForegroundObserver: AnyObject!
    
    @IBOutlet weak var profileImage: UIImageView!
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBOutlet weak var dislikeButton: UIButton!
    @IBAction func likeButton(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

