//
//  Workout.swift
//  Buddy Up
//
//  Created by Kyle Phan on 4/27/17.
//  Copyright © 2017 Kyle Phan. All rights reserved.
//

import Foundation
import UIKit
import AWSDynamoDB

class Workout: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _daysOfTheWeek: [String]?
    var _workout: [String]?
    
    class func dynamoDBTableName() -> String {
        
        return "buddyup-mobilehub-1267115472-Workout"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "_userId"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_userId" : "userId",
            "_daysOfTheWeek" : "daysOfTheWeek",
            "_workout" : "workout",
        ]
    }
}
