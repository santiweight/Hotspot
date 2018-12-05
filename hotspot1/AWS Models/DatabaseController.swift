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
    
    var deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
    
    /*
     queries for specified event, adds attendee to the event and then updates the
     DB with the updated event information.
    */
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
                            item._atEvent?.append(attendee)
                            self.updateEventDb(event: item)
                        }
                    }
                }
        })
    }

    func atEvent(event: Event) {
        //TODO
    }
    
    func attendEvent(event: Event, attendee: String) {
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
                            print("here")
                            self.updateEventDb(event: item)
                        }
                    }
                }
        })
    }
    
    /*
     queries the database by event title and the session uuid
     if there is a response the function loops through and prints Event ID
     *add a callback function below if need.
    */
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
                    } else {
                        for item in (response?.items)! as! [EventTable2]{
                            //insert callback function here
                            print(item._eventId)
                        }
                    }
                }
            })
    }

    /*
     Scans Table for all events then uses a callback funciton to populate
     map
    */
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
    
    /*
     overload Takes in a AWS event Model object and updates the database with the new OBJ
     */
    func updateEventDb(event: EventTable2){
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let userEvent = Event()
        
        userEvent.queryObjToUserEvent(qObj: event)
        event._eventId = userEvent.getStrHashValue()
        
        objectMapper.save(event, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print(" Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was updated.")
        })
    }
    
    /*
     updates database with a event.
    */
    func updateEventDb(event: Event){
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let itemToCreate:EventTable2 = event.userEventToQueryObj()
        
        itemToCreate._eventId = event.getStrHashValue()
        
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
