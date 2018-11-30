//
//  EventManager.swift
//  hotspot1
//
//  Created by cs121 on 11/28/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import UIKit
import CoreLocation

class EventManager: UIViewController, CLLocationManagerDelegate {
    
    let DEFAULT_RADIUS : Double = 20
    
    var trackedEvents = Set<Event>()
    
    var localLocationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    func startMonitoring(event: Event) {
        makeEventRegion(localLocationManager, latitude: event._latitude, longitude: event._longitude, radius: DEFAULT_RADIUS, identifier: String(event.hash))
        trackedEvents.insert(event)
    }
    
    func stopMonitoring(event: Event) {
        //takes event_id and removes it from tracked regions
        let delRegion : CLRegion = localLocationManager.monitoredRegions.first(where: {$0.identifier == String(event.hash)})!
        localLocationManager.stopMonitoring(for: delRegion)
        print(String(event.description) + " successfully removed!")
    }
    
    func initializeLocationServices() {
        localLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        localLocationManager.delegate = self
        startLocation = nil
        requestLocationServices()
    }
    
    func requestLocationServices() {
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.restricted {
            //LOCATION SERVICES DENIED FOR THIS APP
            return
        }
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            localLocationManager.requestAlwaysAuthorization()
            if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways {
                localLocationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            initializeLocationServices()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        //DO NOTHING
    }
    
    func makeEventRegion(_ manager: CLLocationManager, latitude: Double, longitude: Double, radius: Double, identifier: String) {
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: radius, identifier: identifier )
        
        if !CLLocationManager.isMonitoringAvailable(for: Event.self) {
            //ERROR - monitoring not available on device
            return
        }
        
        manager.startMonitoring(for: region)
    }
    
}

