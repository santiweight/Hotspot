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
import UIKit

var deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
let HASH_MULT = 101



func eventIdQuery(event: Event, eventTitle: String){
    
    let obejectMapper = AWSDynamoDBObjectMapper.default()
    let queryExpression = AWSDynamoDBQueryExpression()
    
    queryExpression.keyConditionExpression = "#userId = :userId and #title = :title"
    queryExpression.expressionAttributeNames = [
        "#userId": "userId",
        "#title": "title",
    ]
    
    queryExpression.expressionAttributeValues = [
        ":userId" : deviceID,
        ":title" : eventTitle,
    ]
    
    obejectMapper.query(EventTable.self, expression: queryExpression, completionHandler:
        {(response: AWSDynamoDBPaginatedOutput?, error: Error?) -> Void in
            
            if let error = error{
                print("Amazon DynamoDB Save Error: \(error)")
            }
            DispatchQueue.main.sync(execute: {
                print("querying")
                //got a response
                if(response != nil){
                    print("got a repsonse")
                    
                    if(response?.items.count == 0){
                        print("count was 0")
                        //then take our object and put it in DB?
                    }
                    else {
                        for item in (response?.items)! as! [EventTable]{
                            //we found the objects we want
                            let userEvent = Event()
                            userEvent.queryObjToUserEvent(qObj: item)
                    }
                }
            }
        })
    })
}

//#include "stringhash.hpp"
//
//using std::string;
//
//using uchar = unsigned char;
//using uint = unsigned int;
//const uint HASH_MULTIPLIER = 101;
//
//size_t myhash(const string& str)
//{
//    uint hashval = 0;
//    for (uchar c: str) {
//        hashval = hashval * HASH_MULTIPLIER + c;
//    }
//    return hashval;
//}


func getEvents(indexType: String, indexVal: String){
    let scanExpression = AWSDynamoDBScanExpression()
    scanExpression.limit = 50
    let om = AWSDynamoDBObjectMapper.default()
    
    if(indexType != "ALL"){
        scanExpression.filterExpression = indexType + " = :val"
        scanExpression.expressionAttributeValues = [":val": indexVal]
    }
    
    om.scan(EventTable.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
        if let error = task.error as NSError? {
            print("The request failed. Error: \(error)")
        }
        else if let paginatedOutput = task.result {
            for event in paginatedOutput.items as! [EventTable] {
                let userEvent = Event()
                userEvent.queryObjToUserEvent(qObj: event)
                
                print(event)
                //EthanPlotFunc()
            }
        }
        return 0
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
