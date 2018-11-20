//
//  Events.swift
//  MySampleApp
//
//
// Copyright 2018 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.21
//

import Foundation
import UIKit
import AWSDynamoDB

@objcMembers
class Events: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _attendees: [String]?
    var _description: String?
    var _eventID: String?
    var _expectedAttendees: NSNumber?
    var _filters: [String]?
    var _location: [String]?
    var _title: String?
    var _userEmail: String?
    
    class func dynamoDBTableName() -> String {

        return "hotspot-mobilehub-849333022-Events"
    }
    
    class func hashKeyAttribute() -> String {

        return "_userId"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_userId" : "userId",
               "_attendees" : "attendees",
               "_description" : "description",
               "_eventID" : "eventID",
               "_expectedAttendees" : "expectedAttendees",
               "_filters" : "filters",
               "_location" : "location",
               "_title" : "title",
               "_userEmail" : "userEmail",
        ]
    }
}
