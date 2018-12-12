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
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    
    var eventArr: Array<Event> = Array()
    
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
                    
                    userEvent._latitude = event._latitude as? Double
                    userEvent._longitude = event._longitude as? Double
                    
                    // check if event is desired one, if so, call enterDate
                    if(userEvent._title == self.name){
                        self.enterData(event: userEvent)
                    }
                }
            }
            return nil
        })
    }
    
    // this function simply sets label values to data from the specific event.
    func enterData(event: Event){
        DispatchQueue.main.async {
            //code that caused error goes here
            self.descLabel?.text = event._description
            self.hostLabel?.text = event._userEmail
            self.test?.text = event._title
            self.idLabel?.text = String(describing: event._event_id)
            self.addressLabel?.text = event._address
            self.timeLabel?.text = "\(Event.dateComponentToString(dc: event._startTime)) - \(Event.dateComponentToString(dc: event._endTime) )"
            //self.test?.text = event._title
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        getEvents(indexType: "ALL", indexVal: "ALL")
        
    }
    

}
