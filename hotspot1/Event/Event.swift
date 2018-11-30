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
    
    let deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        if(lhs._event_id == rhs._event_id){
            return true
        }
        return false
    }
    
    
    var _event_id:      String!
    var _user_id:       String!
    var _creator_email: String!
    var _title:         String!
    var _address:       String!
    var _description:   String!
    var _start:         String!
    var _end:           String!
    var _attendees:     [String]!
    var _expectedAttendees: Int!
    var _latitude:      Double!
    var _longitude:     Double!
    var _year_filters:  [String]!
    var _school_filters: [String]!
    
    init(creator_email: String, title: String, address: String, description: String, start: String, end: String, attendees: [String], expectedAttendees: Int, latitude: Double, longitude: Double, year_filters: [String], school_filters: [String]){
        _event_id      = "NULL"
        _user_id       = deviceID
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
        _event_id      = "NULL"
        _user_id       = deviceID
        _creator_email = "NULL"
        _title         = "NULL"
        _address       = "NULL"
        _description   = "NULL"
        _start         = "NULL"
        _end           = "NULL"
        _attendees     = ["NULL"]
        _expectedAttendees = 0
        _latitude      = 0.0
        _longitude     = 0.0
        _year_filters  = ["NULL"]
        _school_filters = ["NULL"]
        
    }
    
    func setDate(start: String, end: String){
        _start = start
        _end   = end
    }
    
    func userEventToQueryObj() -> EventTable{
        let qObj:EventTable = EventTable()
        
        //TODO
        //qObj._event_id = _event_id
        qObj._userId = _user_id
        qObj._userEmail = _creator_email
        qObj._title = _title
        qObj._address = _address
        qObj._description = _description
        qObj._startTime = _start
        qObj._endTime = _end
        qObj._expectedAttendence = ["NULL"]
        qObj._latitude = _latitude as NSNumber
        qObj._longitude = _longitude as NSNumber
        qObj._school = "NULL"
        qObj._year = 0 as NSNumber
        
        qObj._eventType = "NULL"
        
        return qObj
        
    }
/*:
     function converts a DateComponents object to a string. function makes sure
     that nil cannot be returned as AWS Dynamo DB cannot process nil
 */
    func dateComponenetsToString(dateIn: DateComponents) -> String{
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.weekOfMonth ,NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second]
        
        let dateString = formatter.string(from: dateIn)
        if(dateString == nil){
            return ""
        }
        return dateString!
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
    
    func getStrHashValue() -> String {
        return String(hashValue)
        
    }
    
    var hashValue: Int {
        let hashStr = _title + _user_id
        return hashStr.hashValue
    }
}
