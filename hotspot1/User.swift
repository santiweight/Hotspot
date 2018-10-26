//
//  User.swift
//  hotspot1
//
//  Created by Zack Rossman on 10/26/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import Foundation

class User{
    var _user_email: String!;
    var _first_name: String;
    var _last_name: String;
    var _filters: [String]!;
    
    init(user_email: String, first_name: String, last_name: String, filters: [String]){
        _user_email = user_email;
        _first_name = first_name;
        _last_name = last_name;
        _filters = filters;
    }
}
