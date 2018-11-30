//
//  User.swift
//  hotspot1
//
//  Created by Zack Rossman on 10/26/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import Foundation

class User{
    var _email: String!
    var _firstName: String!
    var _lastName: String!
    var _school: String!
    var _year: String!
    
    init(userEmail: String, firstName: String, lastName: String, school: String, year: String){
        _email = userEmail
        _firstName = firstName
        _lastName = lastName
        _school = school
        _year = year
    }
}
