//
//  Event.swift
//  hotspot1
//
//  Created by Zack Rossman on 10/26/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import Foundation

class Event{
    var _event_id: Int!;
    var _creator_email: String!;
    var _start_t: Date!;
    var _end_t: Date!;
    var _attendees: [String]!;
    var _latitude: Double!;
    var _longitude: Double!;
    var _filters: [Int]!;
    
    init(event_id: Int, creator_email: String, start_t: Date, attendees: [String], latitude: Double, longitude: Double, filters: [Int]){
        _event_id = event_id;
        _creator_email = creator_email;
        _start_t = start_t;
        _attendees = attendees;
        _latitude = latitude;
        _longitude = longitude;
        _filters = filters;
    }
}
