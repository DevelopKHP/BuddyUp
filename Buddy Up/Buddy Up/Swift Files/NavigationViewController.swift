//
//  NavigationViewController.swift
//  Buddy Up
//
//  Created by Kyle Phan on 3/30/17.
//  Copyright © 2017 Kyle Phan. All rights reserved.
//

import UIKit
import AWSMobileHubHelper

class NavigationViewController: UIViewController {

    var willEnterForegroundObserver: AnyObject!
    var matchFlag : Bool!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var matchButton: UIButton!
    @IBOutlet weak var workoutButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !(AWSIdentityManager.default().isLoggedIn) {
            DispatchQueue.main.async(execute: {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "SignIn")
                self.present(viewController, animated: true, completion: nil)
            })
        }
        else{
            willEnterForegroundObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.current) { _ in
            }
        }
    }
    
    
    @IBAction func signOut(_ sender: UIButton){
        handleLogout()
    }
    

    
    @IBAction func navigateHome(_ sender: UIButton) {
        if(self.parent?.restorationIdentifier! == "Home"){
            print("Already in Home Page")
        }
        else{
            //DispatchQueue.main.async(execute: {
                self.homeButton.setTitleColor(UIColor.black, for: [])
                self.matchButton.setTitleColor(UIColor.orange, for: [])
                self.workoutButton.setTitleColor(UIColor.orange, for: [])
                self.profileButton.setTitleColor(UIColor.orange, for: [])
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
                self.present(viewController, animated: true, completion: nil)
                //UIApplication.shared.keyWindow?.rootViewController = viewController
            //})

        }

    }
    
    @IBAction func navigateMatch(_ sender: UIButton) {
        if(self.parent?.restorationIdentifier! == "Match"){
            print("Already in Match Page")
        }
        else{
            //DispatchQueue.main.async(execute: {
                self.homeButton.setTitleColor(UIColor.orange, for: [])
                self.matchButton.setTitleColor(UIColor.black, for: [])
                self.workoutButton.setTitleColor(UIColor.orange, for: [])
                self.profileButton.setTitleColor(UIColor.orange, for: [])
                let storyboard = UIStoryboard(name: "Match", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "Match")
                self.present(viewController, animated: true, completion: nil)
                //UIApplication.shared.keyWindow?.rootViewController = viewController
            //})
        }
    }
    
    @IBAction func navigateWorkout(_ sender: UIButton) {
        if(self.parent?.restorationIdentifier! == "Workout"){
            print("Already in Workout Page")
        }
        else{
            //DispatchQueue.main.async(execute: {
                self.homeButton.setTitleColor(UIColor.orange, for: [])
                self.matchButton.setTitleColor(UIColor.orange, for: [])
                self.workoutButton.setTitleColor(UIColor.black, for: [])
                self.profileButton.setTitleColor(UIColor.orange, for: [])
                let storyboard = UIStoryboard(name: "Workout", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "Workout")
                self.present(viewController, animated: true, completion: nil)
                //UIApplication.shared.keyWindow?.rootViewController = viewController
            //})
        }
    }
    
    @IBAction func navigateProfile(_ sender: UIButton) {
        if(self.parent?.restorationIdentifier! == "Profile"){
            print("Already in Profile Page")
        }
        else{
            //DispatchQueue.main.async(execute: {
                self.homeButton.setTitleColor(UIColor.orange, for: [])
                self.matchButton.setTitleColor(UIColor.orange, for: [])
                self.workoutButton.setTitleColor(UIColor.orange, for: [])
                self.profileButton.setTitleColor(UIColor.black, for: [])
                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "Profile")
                self.present(viewController, animated: true, completion: nil)
                //UIApplication.shared.keyWindow?.rootViewController = viewController
            //})
        }

    }
        
    func presentSignInViewController() {
        if !(AWSIdentityManager.default().isLoggedIn) {
            DispatchQueue.main.async(execute: {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "SignIn")
                self.present(viewController, animated: true, completion: nil)
                UIApplication.shared.keyWindow?.rootViewController = viewController
            })
        }
    }
    
    
    
    // MARK: - UITableViewController delegates
    
    
    
    func handleLogout() {
        if (AWSIdentityManager.default().isLoggedIn) {
            AWSIdentityManager.default().logout(completionHandler: {(result: Any?, error: Error?) in
                DispatchQueue.main.async(execute: {
                    self.presentSignInViewController()
                })
            })
            // print("Logout Successful: \(signInProvider.getDisplayName)");
        } else {
            DispatchQueue.main.async(execute: {
                self.presentSignInViewController()
            })

        }
    }
}

