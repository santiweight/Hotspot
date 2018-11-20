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

protocol DBInterface {
    func eventIdQuery(eventTitle: String)
    func updateEventDb(event: Event)
    func atEvent(eventID: Int, attendee: String)
    func attendEvent(event: Event, attendee: String)
}

class DatabaseController: DBInterface {

    func atEvent(eventID: Int, attendee: String) {
        //TODO
    }
    
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
                            print(userEvent)
                    }
                }
            }
        })
    })
}

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
                //addEventToMap(userEvent)
            }
        }
        return nil
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
}
