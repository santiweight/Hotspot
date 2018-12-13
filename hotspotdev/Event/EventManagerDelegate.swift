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
        EventManager.shared.manager.requestLocation()
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
        let attendTarget = EventManager.shared.trackedEvents.first(where: {String($0.hash) == region.identifier})
        DynamoDBManager.shared.atEvent(event: attendTarget!, attendee: OktaManager.shared.getSessionInfo()["sessionEmail"]!)
        EventManager.shared.trackedEvents = EventManager.shared.trackedEvents.filter({String($0.hash) != region.identifier})
        EventManager.shared.updateEventsTracked()
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        //DO NOTHING
    }
}
