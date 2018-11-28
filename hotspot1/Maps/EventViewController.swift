//
//  EventViewController.swift
//  hotspot1
//
//  Created by Ethan Lloyd Lewis on 11/5/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import UIKit
import AWSCore
import AWSDynamoDB

class EventViewController: UIViewController {

    var name = ""
    var id2 = ""
    
    var address = ""
    var time = ""
    var desc = ""
    var host = ""
    
    

    @IBOutlet weak var backButton: UIButton!

    
    // test = name

    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    
    var deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
    
    func eventIdQuery(eventTitle: String){
        
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
                        for item in (response?.items)!{
                            //we found the objects we want
                            if(item.value(forKey: "_userId") != nil){
                                if let existingID = item.value(forKey: "_userId"){
                                    print("item")
                                    print(existingID)
                                }
                            }
                        }
                    }
                }
                //})
        })
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // attempting to set border around tittle of event
        // test.layer.borderColor = UIColor.orange.cgColor
        
        
        test?.text = name
        idLabel?.text = id2
        eventIdQuery(eventTitle: name)
        // let event: Event = db.eventIdQuery(eventTitle: name)
        
        
        // querery database for rest of info.
        descLabel?.text = desc
        addressLabel?.text = address
        hostLabel?.text =  host
        timeLabel?.text = time
    }
    

}
