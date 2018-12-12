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
    
    @IBAction func printCoord(_ sender: Any) {
        EventManager.manager.requestLocation()
        print("User Location: \n\(EventManager.manager.location?.coordinate.latitude ?? 0) \n\(EventManager.manager.location?.coordinate.longitude ?? 0)")
    }
    
    @IBAction func printEvents(_ sender: Any) {
        print("testing event tracking")
        for event in EventManager.trackedEvents {
            print( event.description )
            _ = EventManager.manager.location
        }
        print("\n\n")
        EventManager.manager.requestLocation()

        for region in EventManager.manager.monitoredRegions {
            print("\(region.identifier):\n \(EventManager.manager.requestState(for: region))")
        }
    }
}
