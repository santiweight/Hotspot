//
//  StarbucksAnnotation.swift
//  CustomCalloutView
//
//  Created by Malek Trabelsi on 12/17/17.
//  Copyright © 2017 Medigarage Studios LTD. All rights reserved.
//


import MapKit

class EventAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var desc: String!
    var name: String!
    var hotness: String!
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
