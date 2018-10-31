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
    var _filters:       [Int]!
    
    init(event_id: Int, creator_email: String, title: String, address: String, description: String, start: DateComponents, end: DateComponents, attendees: [String], expectedAttendees: Int, latitude: Double, longitude: Double, filters: [Int]){
        _event_id      = event_id
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
        _filters       = filters
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
