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
        var latitude:  Double?
        var longitude: Double?
        var isEmpty : Bool
        
        init(formattedAddress: String? = nil,
             latitude: Double?  = nil,
             longitude: Double? = nil){
            self.formattedAddress = formattedAddress
            self.latitude  = latitude
            self.longitude = longitude
            self.isEmpty = false
        }
        
        init(){
            self.isEmpty = true
        }
    }
    
    static func getLocation(address: String, completionHandler: @escaping (EventLocation?, Error?) -> ()){
        
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
    static func JSONToLocation(JSON: NSDictionary)->EventLocation{
        print(JSON)
        let status = JSON["status"] as! String
        if(status != "OK"){
            //return an empty EventLocation obj
            return EventLocation()
        }
        
        //navigate nested JSON dictionaries
        let results = JSON["results"] as! [[String:Any]]
        let geometry   = results[0]["geometry"] as! NSDictionary
        let location   = geometry["location"] as! NSDictionary
        
        //get relevant vals from appropriate JSON dictionaries
        let formattedAddress = results[0]["formatted_address"] as! String;
        let latitude  = location["lat"] as! Double
        let longitude = location["lng"] as! Double

        //initialize & return a stuct with these vals
        let eventLocation = EventLocation(
            formattedAddress:formattedAddress,
            latitude: latitude,
            longitude: longitude)
        
        return eventLocation
    }
}
