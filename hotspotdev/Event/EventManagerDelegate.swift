//
//  EventManagerDelegate.swift
//  hotspot1
//
//  Created by cs121 on 12/2/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class EventManagerDelegate : UIViewController, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        var state_str : String
        switch state {
        case .inside:
                state_str = "inside"
        case .outside:
                state_str = "outside"
        case .unknown:
                state_str = "unknown"
        }
        EventManager.manager.requestLocation()
        print("\(region.identifier): \(state_str)")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //ATTEND EVENT
        print("At event: \(region.identifier)")
        
        manager.stopMonitoring(for: region)
        let attendTarget = EventManager.trackedEvents.first(where: {String($0.hash) == region.identifier})
        DynamoDBManager.shared.atEvent(event: attendTarget!)
        EventManager.trackedEvents = EventManager.trackedEvents.filter({String($0.hash) != region.identifier})
        EventManager.updateEventsTracked()
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        //DO NOTHING
    }
}
