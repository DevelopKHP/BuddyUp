//
//  FirstLoginViewController.swift
//  Buddy Up
//
//  Created by Kyle Phan on 4/2/17.
//  Copyright © 2017 Kyle Phan. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import AWSMobileHubHelper
import AWSDynamoDB
import FBSDKCoreKit

class FirstLoginViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - View lifecycle
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var bio: UITextView!
    let identityManager = AWSIdentityManager.default()
    let objectMapper = AWSDynamoDBObjectMapper.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        userName.text = identityManager.userName
        
        if let imageURL = identityManager.imageURL {
            let imageData = try! Data(contentsOf: imageURL)
            if let profileImage = UIImage(data: imageData) {
                userImageView.image = profileImage
            } else {
                userImageView.image = UIImage(named: "UserIcon")
            }
        }
        bio.textColor = UIColor.lightGray
        bio.layer.cornerRadius = 5
        bio.clipsToBounds = true
        bio.layer.borderColor =
            UIColor.black.cgColor
        bio.layer.borderWidth = 1.0
        bio.isScrollEnabled = false
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
            bio.text = "Bio"
            bio.textColor = UIColor.lightGray
            bio.clearsOnInsertion = true
        }
    }
    

    @IBAction func save() {
        
        var errors: [NSError] = []
        let group: DispatchGroup = DispatchGroup()
        
        //Adding to All Users Table //
        group.enter()
                // Adding to UserInfo Table //
        let newUser: UserInfo! = UserInfo()
        let name = identityManager.userName?.components(separatedBy: " ")
        newUser._userId = identityManager.identityId!
        newUser._bio = bio.text
        newUser._firstName = name?[0]
        newUser._lastName = name?[(name?.count)! - 1]
        newUser._matches = nil
        newUser._graphRequest = FBSDKAccessToken.current().userID

        
        group.enter()
        
        if(newUser._bio == "Bio"){
            let message: String = "You need to fill out a bio to continue!"
            let alartController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alartController.addAction(dismissAction)
            self.present(alartController, animated: true, completion: nil)
        }
        
        objectMapper.save(newUser, completionHandler: {(error: Error?) -> Void in
            if let error = error as NSError? {
                DispatchQueue.main.async(execute: {
                    errors.append(error)
                })
            }
            group.leave()
        })
        
        // Adding to Workout Table //
        group.enter()
        let intialData: Workout! = Workout()
        let dayOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        let workout = ["Workout of the Day", "Workout of the Day", "Workout of the Day", "Workout of the Day", "Workout of the Day", "Workout of the Day", "Workout of the Day",]
        intialData?._userId = identityManager.identityId
        intialData?._daysOfTheWeek = dayOfWeek
        intialData?._workout = workout
        objectMapper.save(intialData, completionHandler: {(error: Error?) -> Void in
            if let error = error as NSError?{
                DispatchQueue.main.async(execute:{
                    errors.append(error)
                })
                
            }
            group.leave()
        })
        
        
        group.enter()
        DispatchQueue.main.async(execute: {
            let storyboard = UIStoryboard(name: "Pages", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
            self.present(viewController, animated: true, completion: nil)
            group.leave()
            //UIApplication.shared.keyWindow?.rootViewController = viewController
        })

    }

}
