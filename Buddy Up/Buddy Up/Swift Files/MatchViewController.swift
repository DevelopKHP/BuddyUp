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
        
        let scanExpression = AWSDynamoDBScanExpression()
         
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let newUser: UserInfo! = UserInfo()
        objectMapper.scan(UserInfo.self, expression: scanExpression).continueWith { (task:AWSTask<AWSDynamoDBPaginatedOutput>) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            }
            else if (task.result) != nil {
                for i in 1...Int((task.result?.items.count)!){
                    let tableRow = task.result!
                    let description = tableRow.items.description.components(separatedBy: " ")
                    var index = [Int]()
                    let last = description.count - 1
                    for j in (1...last) {
                        if(description[j].range(of: "userId") != nil){
                            print("Hit")
                            print(description[i])
                            print(description[i+2])
                            newUser._allUsers?.insert(description[i+2], at: 0)
                        }
                    }
                }
            }
            
            return nil
        }
        
    }
    @IBOutlet weak var dislikeButton: UIButton!
    @IBAction func likeButton(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

