//
//  DatabaseController.swift
//  hotspot1
//
//  Created by clinic18 on 11/12/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import Foundation
import AWSCore
import AWSDynamoDB

var deviceID = (UIDevice.current.identifierForVendor?.uuidString)!

func eventIdQuery(event: Event){
    let obejectMapper = AWSDynamoDBObjectMapper.default()
    let queryExpression = AWSDynamoDBQueryExpression()
    
    queryExpression.keyConditionExpression = "#userID = :userID"
    queryExpression.expressionAttributeNames = [
        "#userID": "userID",
    ]
    
    queryExpression.expressionAttributeNames = [
        ":userID" : deviceID,
    ]
    
    obejectMapper.query(EventTable.self, expression: queryExpression, completionHandler:
        {(response: AWSDynamoDBPaginatedOutput?, error: Error?) -> Void in
            
            if let error = error{
                print("Amazon DynamoDB Save Error: \(error)")
            }
            DispatchQueue.main.async(execute: {
                print("querying")
                //got a response
                if(response != nil){
                    print("got a repsonse")
                    
                    if(response?.items.count == 0){
                        print("count was 0")
                        //then take our object and put it in DB?
                    } else {
                        for item in (response?.items)!{
                            //we found the objects we want
                            if(item.value(forKey: "_userID") != nil){
                                
                                if let existingID = item.value(forKey: "_userID"){
                                    print(existingID)
                                }
                            }
                        }
                    }
                }
            })
    })
}

func updateEventDb(event: Event){
    
    let objectMapper = AWSDynamoDBObjectMapper.default()
    let itemToCreate:EventTable = event.userEventToQueryObj()
    
    objectMapper.save(itemToCreate, completionHandler: {(error: Error?) -> Void in
        if let error = error{
            print("Amazon DynamoDB Save Error: \(error)")
        }
        else{
            print("Event Data saved")
        }
    })
}
