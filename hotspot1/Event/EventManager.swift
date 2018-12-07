//
//  EventManager.swift
//  hotspot1
//
//  Created by cs121 on 11/28/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import UIKit
import CoreLocation

class EventManager : UIViewController {

    static let cal = Calendar(identifier: .gregorian)

    static let DEFAULT_RADIUS : Double = 1000

    static var trackedEvents : [Event] = []

    static let manager: CLLocationManager = CLLocationManager()

    static let delegate = EventManagerDelegate()
    
    static func trackEvent(event: Event) {
        trackedEvents.append(event)
        updateEventsTracked()
    }

    static func startMonitoring(event: Event) {
        monitorEventRegion(manager, latitude: event._latitude, longitude: event._longitude, radius: DEFAULT_RADIUS, identifier: String(event.hash))
    }

    static func stopTracking(event: Event) {
        //takes event_id and removes it from tracked regions and tracked events
        if let delRegion = manager.monitoredRegions.first(where: {$0.identifier == String(event.hash)}) {
            manager.stopMonitoring(for: delRegion)
        }
        trackedEvents = trackedEvents.filter({$0.hash != event.hash})
        updateEventsTracked()
    }

    static func initializeLocationServices() {
        requestLocationServices()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = delegate
    }

    static func requestLocationServices() {
        manager.requestAlwaysAuthorization()
//        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.restricted {
//            //LOCATION SERVICES DENIED FOR THIS APP
//            return
//        }
//        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
//            manager.requestAlwaysAuthorization()
//            if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways {
//
//                manager.allowsBackgroundLocationUpdates = true
//                manager.startUpdatingLocation()
//            }
//            else {
//                manager.requestWhenInUseAuthorization()
//                if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
//                    manager.startUpdatingLocation()
//                }
//            }
//
//        }
    }

    static func monitorEventRegion(_ manager: CLLocationManager, latitude: Double, longitude: Double, radius: Double, identifier: String) {
        
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: radius, identifier: identifier )
        region.notifyOnEntry = true
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            //ERROR - monitoring not available on device
            return
        }
        manager.startMonitoring(for: region)
    }

    static func stopMonitoringAllRegions() {
        for region in manager.monitoredRegions {
            manager.stopMonitoring(for: region)
        }
    }

    static func checkDatesOrdered(start: DateComponents, end: DateComponents) -> Bool{
        let startDate = cal.date(from: start)
        let endDate = cal.date(from: end)
        let dateComp = cal.compare(startDate!, to: endDate!, toGranularity: Calendar.Component.minute)

        return dateComp == ComparisonResult.orderedAscending
    }

    static func updateEventsTracked()
    {

        if trackedEvents.count > 20 {
            stopMonitoringAllRegions()

            trackedEvents = trackedEvents.sorted(by: {checkDatesOrdered( start: $0._startTime!, end: $1._startTime!) } )

            let firstEvents = trackedEvents[0..<20]
            for event in firstEvents {
                trackEvent(event: event)
            }
        }
        for event in trackedEvents {
            startMonitoring(event: event)
        }
    }
    
    func stringToDateC(date: Date) -> DateComponents{
        var dc = DateComponents()
        let calendar = Calendar.current
        let bigComponents = calendar.dateComponents([.day,.month,.year], from: date)
        dc.year = bigComponents.year
        dc.month = bigComponents.month
        dc.day = bigComponents.day
        
        //get time info from picker
        let smallComponents = calendar.dateComponents([.hour, .minute], from: date)
        dc.hour = smallComponents.hour
        dc.minute = smallComponents.minute
        return dc
    }
}
