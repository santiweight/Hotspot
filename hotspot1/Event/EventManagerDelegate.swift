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
    let db = DatabaseController()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //ATTEND EVENT
        let attend_alert = UIAlertController(title: "Location Update", message: "Attending event \(region.identifier)", preferredStyle: .alert)
        attend_alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(attend_alert, animated: true)
        
        manager.stopMonitoring(for: region)
        let attendTarget = EventManager.trackedEvents.first(where: {String($0.hash) == region.identifier})
        db.atEvent(event: attendTarget!)
        EventManager.trackedEvents = EventManager.trackedEvents.filter({String($0.hash) != region.identifier})
        EventManager.updateEventsTracked()
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        //DO NOTHING
    }
}
