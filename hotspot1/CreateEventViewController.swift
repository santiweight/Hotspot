//
//  CreateEventViewController.swift
//  hotspot1
//
//  Created by Zack Rossman on 10/26/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import Foundation
import UIKit

class CreateEventViewController: UIViewController {
    
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventAddress: UITextField!
    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var expectedAttendees: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createEvent(_ sender: Any) {
        var startComponents = DateComponents()
        startComponents.year = 2018
        startComponents.month = 12
        startComponents.day = 10
        startComponents.month = 2
        startComponents.minute = 30
        
        var endComponents = DateComponents()
        endComponents.year = 2019
        endComponents.month = 12
        endComponents.day = 10
        endComponents.month = 2
        endComponents.minute = 30
        
        var newEvent = Event(event_id: 1, creator_email: "zackrossman10@gmail.com", title: eventTitle.text, description: eventDescription, start: startComponents, end: endComponents, attendees: ["zackrossman10@gmail.com"], expectedAttendees: expectedAttendees, latitude: 100.1, longitude: 100.1, filters: [1])
        
    }
    
}



