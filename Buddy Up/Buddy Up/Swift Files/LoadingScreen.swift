//
//  LoadingScreen.swift
//  Buddy Up
//
//  Created by Kyle Phan on 5/6/17.
//  Copyright © 2017 Kyle Phan. All rights reserved.
//

import Foundation
import UIKit
import AWSMobileHubHelper
import AWSDynamoDB


class LoadingScreenController: UIViewController {
    let objectMapper = AWSDynamoDBObjectMapper.default()
    let identityManager = AWSIdentityManager.default()
    var newUser: UserInfo! = UserInfo()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        activityIndicator.startAnimating()
        super.viewDidLoad()
        let scanExpression = AWSDynamoDBScanExpression()
        var errors: [NSError] = []
        
        var collection = [String]()
        
        objectMapper.load(UserInfo.self, hashKey: identityManager.identityId as Any, rangeKey:nil).continueWith(block: {
            (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                errors.append(error)
            }
            else if (task.result as? UserInfo) != nil {
                self.newUser = task.result as! UserInfo
                self.objectMapper.scan(UserInfo.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>) -> Any? in
                    if let error = task.error as NSError? {
                        errors.append(error)
                    }
                    else if (task.result) != nil {
                        let tableRow = task.result!
                        let description = tableRow.items.description.components(separatedBy: " ")
                        let last = description.count - 1
                        for i in (1...last) {
                            if(description[i].range(of: "userId") != nil){
                                var addedWord = description[i+2]
                                let start = addedWord.index(addedWord.startIndex, offsetBy: 1)
                                let end = addedWord.index(addedWord.endIndex, offsetBy: -5)
                                let range = start..<end
                                addedWord = addedWord[range]
                                if(addedWord != self.newUser._userId){
                                    var flag = true
                                    if (self.newUser._matches != nil){
                                        for items in self.newUser._matches!{
                                            if(addedWord == items){
                                                flag = false
                                            }
                                        }
                                    }
                                    if (self.newUser._rejected != nil){
                                        for items in self.newUser._rejected!{
                                            if(addedWord == items){
                                                flag = false
                                            }
                                        }
                                    }
                                    if(flag == true){
                                        collection.append(addedWord)
                                    }
                                }
                            }
                        }
                    }
                    if(collection.count != 0){
                        self.newUser._allUsers = collection
                    }
                    
                    self.objectMapper.save(self.newUser, completionHandler: {(error: Error?) -> Void in
                        if let error = error as NSError? {
                            DispatchQueue.main.async(execute: {
                                errors.append(error)
                                print(errors)
                            })
                        }
                        else{
                            DispatchQueue.main.async(execute: {
                                self.activityIndicator.stopAnimating()
                                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                                let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
                                self.present(viewController, animated: true, completion: nil)
                            })
                        }
                    })
                    return nil
                })
            }
            return nil
        })
        
    }
}
