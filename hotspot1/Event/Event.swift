//
//  Event.swift
//  hotspot1
//
//  Created by Zack Rossman on 10/26/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import Foundation

class Event{
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
    
    init(event_id: Int, user_id: String, creator_email: String, title: String, address: String, description: String, start: DateComponents, end: DateComponents, attendees: [String], expectedAttendees: Int, latitude: Double, longitude: Double, year_filters: [String], school_filters: [String]){
        _event_id      = event_id
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
        _event_id      = 0
        _user_id       = "NULL"
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
    
    func setLocation(latitude: Double, longitude: Double){
        _latitude  = latitude
        _longitude = longitude
    }
}
