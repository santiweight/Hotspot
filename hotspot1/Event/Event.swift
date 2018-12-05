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
    var _endTime: DateComponents!
    var _startTime: DateComponents!
    var _expectedAttendence: Int!
    var _latitude: Double!
    var _longitude: Double!
    var _school: String!
    var _title: String!
    var _userEmail: String!
    var _year: Int!
    
    init(user_id: String, event_id: String, address: String, atEvent: [String], attendees: [String], description: String, endTime: DateComponents, startTime: DateComponents, expectedAttencence: Int, latitude: Double, longitude: Double, school: String, title: String, userEmail: String, year: Int){
        
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
    
    static func dateComponentToString(dc: DateComponents)-> String{
        return "\(dc.month) \(dc.day), \(dc.year) \(dc.hour): \(dc.minute)"
    }
    
    static func stringToDateComponents(stringDate: String)-> DateComponents{
        let dcArray = stringDate.components(separatedBy: " ")
        var dc = DateComponents()
        dc.month = Int(dcArray[0])
        dc.day = Int(dcArray[1])
        dc.year = Int(dcArray[2])
        dc.hour = Int(dcArray[3])
        dc.minute = Int(dcArray[4])
        return dc
    }
    
    override init(){
        _user_id = "NULL"
        _event_id = "NULL"
        _address = "NULL"
        _atEvent = ["NULL"]
        _attendees = ["NULL"]
        _description = "NULL"
        _endTime = DateComponents()
        _startTime = DateComponents()
        _expectedAttendence = 0
        _latitude = 0.0
        _longitude = 0.0
        _school = "NULL"
        _title = "NULL"
        _userEmail = "NULL"
        _year = 0
    }
    
    func setDate(start: DateComponents, end: DateComponents){
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
        qObj._startTime = Event.dateComponentToString(dc: _startTime)
        qObj._endTime = Event.dateComponentToString(dc: _endTime)
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
    
    func queryObjToUserEvent(qObj:EventTable2) {
        
        _user_id = qObj._userId
        _event_id = qObj._eventId
        _address = qObj._address
        _atEvent = qObj._atEvent
        _attendees = qObj._attendees
        _description = qObj._description
        _endTime = Event.stringToDateComponents(stringDate: qObj._endTime!)
        _startTime = Event.stringToDateComponents(stringDate: qObj._startTime!)
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
        return "{ event: \(String(describing: _event_id))\n  user: \(_user_id!)\n  creator email: \(_userEmail!)\n  title: \(_title!)\n  address: \(_address!)\n  description: \(_description!)\n  start time:\(_startTime!)\n  end time: \(_endTime!)\n  no. of att: \(_attendees.count)\n  latitude: \(_latitude!)\n  longitude: \(_longitude!)\n  year filters: \(_year!))\n  school filters\(_school!)\n at Event: \(String(describing: _atEvent))"
    }
    
    
}
