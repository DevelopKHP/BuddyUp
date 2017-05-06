//
//  WorkoutViewController.swift
//  Buddy Up
//
//  Created by Kyle Phan on 4/25/17.
//  Copyright © 2017 Kyle Phan. All rights reserved.
//

import Foundation
import UIKit
import AWSMobileHubHelper
import AWSDynamoDB

class WorkoutViewController: UITableViewController{
    
  
    let objectMapper = AWSDynamoDBObjectMapper.default()
    var userWorkout = Workout()
    var identityManager = AWSIdentityManager.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                //navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> WorkoutListCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutListCell")! as! WorkoutListCell
        objectMapper.load(Workout.self, hashKey: identityManager.identityId as Any, rangeKey:nil).continueWith(block: {
            (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            }
            else if (task.result as? Workout) != nil {
                DispatchQueue.main.async(execute: {
                    self.userWorkout = task.result as! Workout
                    
                    print("Error Checking")
                    print(self.userWorkout?._daysOfTheWeek)
                    cell.dayOfWeek.text = self.userWorkout?._daysOfTheWeek?[indexPath.row] as String!
                    cell.workoutOfTheDay.text = self.userWorkout?._workout?[indexPath.row] as String!
                    cell.workoutOfTheDay.restorationIdentifier = self.userWorkout?._daysOfTheWeek?[indexPath.row] as String!
                })
            }
            return nil
        })
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print("Touched")
    }
    
    
    @IBAction func testFuntion(_ sender: UITextField) {
        var errors: [NSError] = []

        let dayOfWeek = sender.restorationIdentifier
        let position = userWorkout?._daysOfTheWeek?.index(of: dayOfWeek!)
        userWorkout?._workout?[position!] = sender.text!
        objectMapper.save(userWorkout!, completionHandler: {(error: Error?) -> Void in
            if let error = error as NSError?{
                DispatchQueue.main.async(execute:{
                    errors.append(error)
                })
                
            }
        })
        tableView.reloadData()
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
    

}


class WorkoutListCell: UITableViewCell, UITableViewDelegate {
    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var workoutOfTheDay: UITextField!
    
    
}
