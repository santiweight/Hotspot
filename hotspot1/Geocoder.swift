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
    
    func getLocation(address: String){
        //construct API request for a given address
        let formattedAddress = address.replacingOccurrences(of: " ", with: "+")
        let geocoderBegRequest : String = "https://maps.googleapis.com/maps/api/geocode/json?address="+formattedAddress+"&key=AIzaSyC5agT4X8NX9Rkio1NB_Bhp1J6au5qCLL8"
        
        //make POST request to Google geocoder API
        Alamofire.request(geocoderBegRequest, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: [:])
            .responseJSON {
                response in switch response.result {
                case .success(let JSON):
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print(JSON)
                        let results = JSON["results"] as! [[String:Any]]
                        let address = results[0]["formatted_address"] as! String;
                        print(address)
                        
                        let geometry = results[0]["geometry"] as! NSDictionary
                        let lat = geometry[0]
                        let long = geometry[0]
                    }
    
//                    let json = JSON(data: response.data!)
//                    let name = json["results"]["formatted_address"].string
////                    print(JSON)
////                    let response = JSON as! NSDictionary
////
////                    //example if there is an id
////                    let userId = response.object(forKey: "results")!
//                    print(name)
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
        return
    }
}
