//
//  EventManagerTestPage.swift
//  hotspot1
//
//  Created by cs121 on 11/30/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class EventManagerTestPage : UIViewController {
    
    let event_manager = EventManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            EventManager.initializeLocationServices()
        }
        else {
            EventManager.requestLocationServices()
            if CLLocationManager.locationServicesEnabled() {
                EventManager.initializeLocationServices()
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func printEvents(_ sender: Any) {
        print("testing event tracking")
        for event in EventManager.trackedEvents {
            print( event.description )
        }
        print("\n\n")
        
        for region in EventManager.manager.monitoredRegions {
            print(region.identifier)
        }
    }
    
    
}
