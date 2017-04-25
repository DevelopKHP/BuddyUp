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
import AWSDynamoDB

class ProfileViewController: UIViewController{

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var bio: UITextView!
    var user = UserInfo()
    var willEnterForegroundObserver: AnyObject!
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        willEnterForegroundObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.current) { _ in
        }
        
        presentSignInViewController()
        
        let identityManager = AWSIdentityManager.default()
        
        
        userName.text = identityManager.userName
        if let imageURL = identityManager.imageURL {
            let imageData = try! Data(contentsOf: imageURL)
            if let profileImage = UIImage(data: imageData) {
                userImageView.image = profileImage
            } else {
                userImageView.image = UIImage(named: "UserIcon")
            }
        }
        objectMapper.load(UserInfo.self, hashKey: identityManager.identityId as Any, rangeKey:nil).continueWith(block: {
            (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            }
            else if (task.result as? UserInfo) != nil {
                DispatchQueue.main.async {
                    self.user = task.result as! UserInfo
                    self.bio.text = self.user?._bio
                }
            }
            return nil
        })
        DispatchQueue.main.async(){
            self.bio.textColor = UIColor.lightGray
            self.bio.layer.cornerRadius = 5
            self.bio.clipsToBounds = true
            self.bio.layer.borderColor =
            UIColor.black.cgColor
            self.bio.layer.borderWidth = 1.0
            self.bio.isScrollEnabled = false
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        if(bio.text == ""){
            bio.text = self.user?._bio
            bio.textColor = UIColor.lightGray
            bio.clearsOnInsertion = true
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        //resets profile page
        bio.text = self.user?._bio
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        //updates profile page
        let identityManager = AWSIdentityManager.default()
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let group: DispatchGroup = DispatchGroup()
        var errors: [NSError] = []

        
        let newUser: UserInfo! = UserInfo()
        let name = identityManager.userName?.components(separatedBy: " ")
        newUser._userId = identityManager.identityId!
        newUser._bio = bio.text
        newUser._firstName = name?[0]
        newUser._lastName = name?[(name?.count)! - 1]
        newUser._matches = nil
        
        group.enter()
        objectMapper.save(newUser, completionHandler: {(error: Error?) -> Void in
            if let error = error as NSError? {
                DispatchQueue.main.async(execute: {
                    errors.append(error)
                })
            }
            group.leave()
        })
        DispatchQueue.main.async(execute: {
            let storyboard = UIStoryboard(name: "Pages", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
            self.present(viewController, animated: true, completion: nil)
            //UIApplication.shared.keyWindow?.rootViewController = viewController
        })

    }
    
    func presentSignInViewController() {
        if !AWSIdentityManager.default().isLoggedIn {
            let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SignIn")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: - UITableViewController delegates
    
    
    
    func handleLogout() {
        if (AWSIdentityManager.default().isLoggedIn) {
            AWSIdentityManager.default().logout(completionHandler: {(result: Any?, error: Error?) in
                self.navigationController!.popToRootViewController(animated: false)
                self.presentSignInViewController()
            })
            // print("Logout Successful: \(signInProvider.getDisplayName)");
        } else {
            assert(false)
        }
    }
}

