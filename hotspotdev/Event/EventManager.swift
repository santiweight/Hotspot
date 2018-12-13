//
//  EventManager.swift
//  hotspot1
//
//  Created by cs121 on 11/28/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import UIKit
import CoreLocation

class EventManager{
    
    static let shared = EventManager()

    private init(){}

    let cal = Calendar(identifier: .gregorian)
    let DEFAULT_RADIUS : Double = 1000
    var trackedEvents : [Event] = []
    let manager: CLLocationManager = CLLocationManager()
    let delegate = EventManagerDelegate()
    
    func trackEvent(event: Event) {
        trackedEvents.append(event)
        updateEventsTracked()
    }

    func startMonitoring(event: Event) {
        monitorEventRegion(manager, latitude: event._latitude, longitude: event._longitude, radius: DEFAULT_RADIUS, identifier: String(event.hash))
    }

    func stopTracking(event: Event) {
        //takes event_id and removes it from tracked regions and tracked events
        if let delRegion = manager.monitoredRegions.first(where: {$0.identifier == String(event.hash)}) {
            manager.stopMonitoring(for: delRegion)
        }
        trackedEvents = trackedEvents.filter({$0.hash != event.hash})
        updateEventsTracked()
    }

    func initializeLocationServices() {
        requestLocationServices()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = delegate
    }

    func requestLocationServices() {
        manager.requestAlwaysAuthorization()
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.restricted {
            //LOCATION SERVICES DENIED FOR THIS APP
            return
        }
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            manager.requestAlwaysAuthorization()
            if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways {

                manager.allowsBackgroundLocationUpdates = true
                manager.startUpdatingLocation()
            }
            else {
                manager.requestWhenInUseAuthorization()
                if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
                    manager.startUpdatingLocation()
                }
            }

        }
    }

    func monitorEventRegion(_ manager: CLLocationManager, latitude: Double, longitude: Double, radius: Double, identifier: String) {
        
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: radius, identifier: identifier )
        region.notifyOnEntry = true
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            //ERROR - monitoring not available on device
            return
        }
        manager.startMonitoring(for: region)
    }

    func stopMonitoringAllRegions() {
//        for region in self.monitoredRegions {
//            manager.stopMonitoring(for: region)
//        }
    }

    func checkDatesOrdered(start: DateComponents, end: DateComponents) -> Bool{
        let startDate = cal.date(from: start)
        let endDate = cal.date(from: end)
        let dateComp = cal.compare(startDate!, to: endDate!, toGranularity: Calendar.Component.minute)

        return dateComp == ComparisonResult.orderedAscending
    }

    func updateEventsTracked()
    {

        if self.trackedEvents.count > 20 {
            self.stopMonitoringAllRegions()

            self.trackedEvents = self.trackedEvents.sorted(by: {self.checkDatesOrdered( start: $0._startTime!, end: $1._startTime!) } )

            let firstEvents = trackedEvents[0..<20]
            for event in firstEvents {
                self.trackEvent(event: event)
            }
        }
        for event in self.trackedEvents {
            self.startMonitoring(event: event)
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
