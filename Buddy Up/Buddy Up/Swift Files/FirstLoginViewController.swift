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

class FirstLoginViewController: UIViewController, UITextViewDelegate {
    
    var willEnterForegroundObserver: AnyObject!
    // MARK: - View lifecycle
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var bio: UITextView!
    let identityManager = AWSIdentityManager.default()
    
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

    @IBAction func insertSampleDataWithCompletionHandler() {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        var errors: [NSError] = []
        let group: DispatchGroup = DispatchGroup()
        
        
        let newUser: UserInfo! = UserInfo()
        let name = identityManager.userName?.components(separatedBy: " ")
        newUser._userId = identityManager.identityId!
        newUser._bio = bio.text
        newUser._firstName = name?[0]
        newUser._lastName = name?[(name?.count)! - 1]
        newUser._matches = nil
        
        
        group.enter()
        
        if(newUser._bio == "Bio"){
            var message: String = "You need to fill out a bio to continue!"
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
        DispatchQueue.main.async(execute: {
            let storyboard = UIStoryboard(name: "Pages", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
            self.present(viewController, animated: true, completion: nil)
            //UIApplication.shared.keyWindow?.rootViewController = viewController
        })

    }

}
