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

class DatabaseController {
    
//    var MVController = MapViewController()
    
    func atEvent(event: Event, attendee: String) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId and #title = :title"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#title": "title",
        ]
        
        queryExpression.expressionAttributeValues = [
            ":userId" : event._user_id,
            ":title" : event._title,
        ]
        
        objectMapper.query(EventTable2.self, expression: queryExpression, completionHandler:
            {(response: AWSDynamoDBPaginatedOutput?, error: Error?) -> Void in
                if let error = error{
                    print("Amazon DynamoDB Save Error: \(error)")
                }
                
                if(response != nil){
                    print("got a repsonse")
                    
                    if(response?.items.count != 1){
                        print("ERROR: got multiple events")
                        //then take our object and put it in DB?
                    } else {
                        //var eventList = []
                        for item in (response?.items)! as! [EventTable2]{
                            item._attendees?.append(attendee)
                            self.updateEvent(event: item)
                        }
                    }
                }
        })
    }
    
    func updateEvent(event: EventTable2){
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        objectMapper.save(event, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print(" Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was updated.")
        })
    }
    
    func attendEvent(event: Event, attendee: String) {
        //TODO
    }

    
    var deviceID = (UIDevice.current.identifierForVendor?.uuidString)!

    func eventIdQuery(eventTitle: String){
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
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
        
        objectMapper.query(EventTable2.self, expression: queryExpression, completionHandler:
            {(response: AWSDynamoDBPaginatedOutput?, error: Error?) -> Void in
                
                if let error = error{
                    print("Amazon DynamoDB Save Error: \(error)")
                }
                //DispatchQueue.main.async(execute: {
                print("querying")
                //got a response
                if(response != nil){
                    print("got a repsonse")
                    
                    if(response?.items.count == 0){
                        print("count was 0")
                        //then take our object and put it in DB?
                    } else {
                        //var eventList = []
                        for item in (response?.items)! as! [EventTable2]{
                            print(eventTitle)
                        }
                    }
                }
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
        
        om.scan(EventTable2.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            }
            else if let paginatedOutput = task.result {
                for event in paginatedOutput.items as! [EventTable2] {
                    let userEvent = Event()
                    userEvent.queryObjToUserEvent(qObj: event)
                    print(event)
                }
            }
            return nil
        })
    }

    func updateEventDb(event: Event){
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let itemToCreate:EventTable2 = event.userEventToQueryObj()
        event._event_id = event.getStrHashValue()
        
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
