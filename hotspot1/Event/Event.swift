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

class Event: NSObject{
    
    let deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        if(lhs._event_id == rhs._event_id && lhs._user_id == rhs._user_id){
            return true
        }
        return false
    }
    
    var _user_id: String!
    var _event_id: String!
    var _address: String!
    var _atEvent: [String]!
    var _attendees: [String]!
    var _description: String!
    var _endTime: String!
    var _startTime: String!
    var _expectedAttendence: Int!
    var _latitude: Double!
    var _longitude: Double!
    var _school: String!
    var _title: String!
    var _userEmail: String!
    var _year: Int!
    
    init(user_id: String, event_id: String, address: String, atEvent: [String], attendees: [String], description: String, endTime: String, startTime: String, expectedAttencence: Int, latitude: Double, longitude: Double, school: String, title: String, userEmail: String, year: Int){
        
        _user_id = user_id
        _event_id = event_id
        _address = address
        _atEvent = atEvent
        _attendees = attendees
        _description = description
        _endTime = endTime
        _startTime = startTime
        _expectedAttendence = expectedAttencence
        _latitude = latitude
        _longitude = longitude
        _school = school
        _title = title
        _userEmail = userEmail
        _year = year
    }
    
    override init(){
        _user_id = "NULL"
        _event_id = "NULL"
        _address = "NULL"
        _atEvent = ["NULL"]
        _attendees = ["NULL"]
        _description = "NULL"
        _endTime = "NULL"
        _startTime = "NULL"
        _expectedAttendence = 0
        _latitude = 0.0
        _longitude = 0.0
        _school = "NULL"
        _title = "NULL"
        _userEmail = "NULL"
        _year = 0
    }
    
    func setDate(start: String, end: String){
        _startTime = start
        _endTime = end
    }
    
    func userEventToQueryObj() -> EventTable2{
        let qObj:EventTable2 = EventTable2()
        
        qObj._userId = _user_id
        qObj._eventId = _event_id
        qObj._address = _address
        qObj._atEvent = _atEvent
        qObj._attendees = _attendees
        qObj._description = _description
        qObj._endTime = _endTime
        qObj._startTime = _startTime
        qObj._expectedAttendence = _expectedAttendence as NSNumber
        qObj._latitude = _latitude as NSNumber
        qObj._longitude = _longitude as NSNumber
        qObj._school = _school
        qObj._title = _title
        qObj._userEmail = _userEmail
        qObj._year = _year as NSNumber
        
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
    
    func queryObjToUserEvent(qObj:EventTable2) {
        
        _user_id = qObj._userId
        _event_id = qObj._eventId
        _address = qObj._address
        _atEvent = qObj._atEvent
        _attendees = qObj._attendees
        _description = qObj._description
        _endTime = qObj._endTime
        _startTime = qObj._startTime
        _expectedAttendence = Int(qObj._expectedAttendence!)
        _latitude = Double(qObj._latitude!)
        _longitude = Double(qObj._longitude!)
        _school = qObj._school
        _title = qObj._title
        _userEmail = qObj._userEmail
        _year = Int(qObj._year!)
    }
    
    
    func setLocation(latitude: Double, longitude: Double){
        _latitude  = latitude
        _longitude = longitude
    }
    
    func getStrHashValue() -> String {
        return String(hashValue)
    }
    
    override var hash: Int {
        let hashStr = _title + _user_id
        return hashStr.hashValue
    }
    
    override var description: String {
        return "{ event: \(_event_id)\n  user: \(_user_id!)\n  creator email: \(_userEmail!)\n  title: \(_title!)\n  address: \(_address!)\n  description: \(_description!)\n  start time:\(_startTime!)\n  end time: \(_endTime!)\n  no. of att: \(_attendees.count)\n  latitude: \(_latitude!)\n  longitude: \(_longitude!)\n  year filters: \(_year))\n  school filters\(_school)\n at Event: \(_atEvent)"
    }
}
