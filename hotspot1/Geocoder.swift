//
//  Geocoder.swift
//  hotspot1
//
//  Created by Zack Rossman on 10/29/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import Foundation
import Alamofire

class Geocoder{
    
    //struct containing relevant info about an event location
    struct EventLocation {
        var formattedAddress: String?
        var topLat:     Double?
        var centerLat:  Double?
        var bottomLat:  Double?
        var leftLong:   Double?
        var centerLong: Double?
        var rightLong:  Double?
        
        init(formattedAddress: String? = nil,
             topLat: Double?     = nil,
             centerLat: Double?  = nil,
             bottomLat: Double?  = nil,
             leftLong: Double?   = nil,
             centerLong: Double? = nil,
             rightLong: Double?  = nil){
            self.formattedAddress = formattedAddress
            self.topLat     = topLat
            self.centerLat  = centerLat
            self.bottomLat  = bottomLat
            self.leftLong   = leftLong
            self.centerLong = centerLong
            self.rightLong  = rightLong
        }
    }
    
    func getLocation(address: String, completionHandler: @escaping (EventLocation?, Error?) -> ()){
        
        //construct API request for a given address
        let formattedAddress = address.replacingOccurrences(of: " ", with: "+")
        let geocoderBegRequest : String = "https://maps.googleapis.com/maps/api/geocode/json?address="+formattedAddress+"&key=AIzaSyC5agT4X8NX9Rkio1NB_Bhp1J6au5qCLL8"
        
        //make POST request to Google geocoder API
        Alamofire.request(geocoderBegRequest, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: [:])
            .responseJSON {
                response in switch response.result {
                case .success(let JSON):
                    let JSON = response.result.value as! NSDictionary
                    let location = self.JSONToLocation(JSON: JSON);
                    completionHandler(location, nil)
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completionHandler(nil, error)
                }
        }
    }
    
    //translate Geocoder API response JSON Object to EventLocation struct
    func JSONToLocation(JSON: NSDictionary)->EventLocation{
        //navigate nested JSON dictionaries
        let results = JSON["results"] as! [[String:Any]]
        let geometry   = results[0]["geometry"] as! NSDictionary
        let location   = geometry["location"] as! NSDictionary
        let bounds = geometry["bounds"] as! NSDictionary
        let northeastBounds = bounds["northeast"] as! NSDictionary
        let southwestBounds = bounds["southwest"] as! NSDictionary
        
        //get relevant vals from appropriate JSON dictionaries
        let formattedAddress = results[0]["formatted_address"] as! String;
        let topLat     = northeastBounds["lat"] as! Double
        let centerLat  = location["lat"] as! Double
        let bottomLat  = southwestBounds["lat"] as! Double
        let leftLong   = southwestBounds["lng"] as! Double
        let centerLong = location["lng"] as! Double
        let rightLong  = northeastBounds["lng"] as! Double

        //initialize & return a stuct with these vals
        let locationStruct = EventLocation(
            formattedAddress: formattedAddress,
            topLat: topLat,
            centerLat: centerLat,
            bottomLat: bottomLat,
            leftLong: leftLong,
            centerLong: centerLong,
            rightLong: rightLong)
        
        return locationStruct
    }
}
