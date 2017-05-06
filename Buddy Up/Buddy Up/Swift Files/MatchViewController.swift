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
    @IBOutlet weak var noMoreMatchesLabel: UILabel!
    @IBOutlet var matchView: UIView!
    
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var disLikeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dislikeLabel: UILabel!
    var userProfile : UserInfo! = UserInfo()
    let objectMapper = AWSDynamoDBObjectMapper.default()
    var errors: [NSError] = []
    var flag : Bool = false
    



    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewWillAppear(true)
        let identityManager = AWSIdentityManager.default()
        var secondProfile : UserInfo! = UserInfo()
        self.objectMapper.load(UserInfo.self, hashKey: identityManager.identityId as Any, rangeKey:nil).continueWith(block: {
            (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                self.errors.append(error)
            }
            else if (task.result as? UserInfo) != nil {
                self.userProfile = task.result as! UserInfo
                if(self.userProfile._allUsers![0] != "None"){
                    self.objectMapper.load(UserInfo.self, hashKey: self.userProfile._allUsers?[0] as Any, rangeKey:nil).continueWith(block: {
                        (task:AWSTask<AnyObject>!) -> Any? in
                        if let error = task.error as NSError? {
                            self.errors.append(error)
                        }
                        else if (task.result as? UserInfo) != nil {
                            secondProfile = task.result as! UserInfo
                            var name = secondProfile._firstName! + " "
                            name.append(secondProfile._lastName!)
                            let imgURLString = "https://graph.facebook.com/" + (secondProfile._graphRequest)! + "/picture?type=large" //type=normal
                            let imgURL = NSURL(string: imgURLString)
                            let imageData = NSData(contentsOf: imgURL! as URL)
                            DispatchQueue.main.async(execute: {
                                self.profileImage.image = UIImage(data: imageData! as Data)
                                self.displayName.text = name
                                
                            })
                        }
                        return nil
                    })
                }
                else{
                    if(self.flag == false){
                        DispatchQueue.main.async(execute: {
                            self.profileImage.isHidden = true
                            self.disLikeButton.isHidden = true
                            self.likeButton.isHidden = true
                            self.displayName.isHidden = true
                            self.noMoreMatchesLabel.isHidden = false
                            self.flag = true
                            self.viewDidLoad()
                        })
                    }
                }
            }
            return nil
        })
        



    }
    
    @IBAction func likeButton(_ sender: UIButton) {
        print("LIKE")
        var listFlag = true
        likeLabel.isHidden = false
        let updateUsers = Array(self.userProfile._allUsers!.dropFirst())
        if(self.userProfile._matches == nil){
            self.userProfile._matches = [String]()
        }
        for items in self.userProfile._matches!{
            if items == (self.userProfile._allUsers![0]){
                listFlag = false
            }
        }
        if (listFlag == true){
            self.userProfile._matches?.append((self.userProfile._allUsers![0]))
        }
        if(updateUsers.count == 0){
             self.userProfile._allUsers![0] = "None"
        }
        else{
            self.userProfile._allUsers = updateUsers
        }
        self.objectMapper.save(self.userProfile, completionHandler: {(error: Error?) -> Void in
            if let error = error as NSError? {
                DispatchQueue.main.async(execute: {
                    self.errors.append(error)
                })
            }
            else{
                
                DispatchQueue.main.async(execute: {
                    self.likeLabel.isHidden = true
                    self.viewDidLoad()
                })


            }
        })
        

    }
    
    @IBAction func dislikeButton(_ sender: UIButton) {
        print("DISLIKE")
        var listFlag = true
        dislikeLabel.isHidden = false
        let updateUsers = Array(self.userProfile._allUsers!.dropFirst())
        if(self.userProfile._rejected == nil){
            self.userProfile._rejected = [String]()
        }
        for items in self.userProfile._rejected!{
            if items == (self.userProfile._allUsers![0]){
                listFlag = false
            }
        }
        if (listFlag == true){
            self.userProfile._rejected?.append((self.userProfile._allUsers![0]))
        }

        if(updateUsers.count == 0){
            self.userProfile._allUsers![0] = "None"
        }
        else{
            self.userProfile._allUsers = updateUsers
        }
        self.objectMapper.save(self.userProfile, completionHandler: {(error: Error?) -> Void in
            if let error = error as NSError? {
                DispatchQueue.main.async(execute: {
                    self.errors.append(error)
                })
                
            }
            else{
                DispatchQueue.main.async(execute: {
                    self.dislikeLabel.isHidden = true
                    self.viewDidLoad()
                })
                
            }
            
            
        })
    }
}

