//
//  Event.swift
//  hotspot1
//
//  Created by Zack Rossman on 10/26/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import Foundation
import UIKit
import AWSCore
import AWSDynamoDB

class Event: Hashable{
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        if(lhs._event_id == rhs._event_id){
            return true
        }
        return false
    }
    
    
    var _event_id:      Int!
    var _user_id:       String!
    var _creator_email: String!
    var _title:         String!
    var _address:       String!
    var _description:   String!
    var _start:         DateComponents!
    var _end:           DateComponents!
    var _attendees:     [String]!
    var _expectedAttendees: Int!
    var _latitude:      Double!
    var _longitude:     Double!
    var _year_filters:  [String]!
    var _school_filters: [String]!
    
    init(user_id: String, creator_email: String, title: String, address: String, description: String, start: DateComponents, end: DateComponents, attendees: [String], expectedAttendees: Int, latitude: Double, longitude: Double, year_filters: [String], school_filters: [String]){
        _event_id      = hashValue
        _user_id       = user_id
        _creator_email = creator_email
        _title         = title
        _address       = address
        _description   = description
        _start         = start
        _end           = end
        _attendees     = attendees
        _expectedAttendees = expectedAttendees
        _latitude      = latitude
        _longitude     = longitude
        _year_filters  = year_filters
        _school_filters = school_filters
    }
    
    init(){
        _event_id      = hashValue
        _user_id       = deviceID
        _creator_email = "NULL"
        _title         = "NULL"
        _address       = "NULL"
        _description   = "NULL"
        _start         = DateComponents()
        _end           = DateComponents()
        _attendees     = ["NULL"]
        _expectedAttendees = 0
        _latitude      = 0.0
        _longitude     = 0.0
        _year_filters  = ["NULL"]
        _school_filters = ["NULL"]
        
    }
    
    func setDate(start: DateComponents, end: DateComponents){
        _start = start
        _end   = end
    }
    
    func userEventToQueryObj() -> EventTable{
        let qObj:EventTable = EventTable()
        
        let deviceid:String = (UIDevice.current.identifierForVendor?.uuidString)!
        //TODO
        //qObj._event_id = _event_id
        qObj._userId = _user_id
        qObj._userEmail = _creator_email
        qObj._title = _title
        qObj._address = _address
        qObj._description = _description
        qObj._startTime = "NULL"
        qObj._endTime = "NULL"
        qObj._expectedAttendence = ["NULL"]
        qObj._latitude = _latitude as NSNumber
        qObj._longitude = _longitude as NSNumber
        qObj._school = "NULL"
        qObj._year = 0 as NSNumber
        
        qObj._eventType = "NULL"
        
        return qObj
        
    }
    
    func queryObjToUserEvent(qObj:EventTable) {
        
        _user_id = qObj._userId
        _creator_email = qObj._userEmail
        _title = qObj._title
        _address = qObj._address
        _description = qObj._description
//        usrEvnt._start = qObj._startTime
//        usrEvnt._end = qObj._endTime
//        usrEvnt._expectedAttendees = qObj._expectedAttendence
//        usrEvnt._latitude = qObj._latitude
//        usrEvnt._longitude = qObj._longitude
//        usrEvnt._school_filters = qObj._school
//        usrEvnt._year_filters = qObj._year
//        usrEvnt._eventType = qObj.EventType
        
    }
    
    
    func setLocation(latitude: Double, longitude: Double){
        _latitude  = latitude
        _longitude = longitude
    }
    
    var hashValue: Int {
        return (_title + deviceID).hashValue
    }
}
