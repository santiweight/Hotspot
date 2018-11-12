//
//  ViewController.swift
//  HotspotLocationManager
//
//  Created by cs121 on 11/4/18.
//  Copyright © 2018 cs121. All rights reserved.
//

import UIKit
import CoreLocation

class EventManager: UIViewController, CLLocationManagerDelegate {

    let defaultRadius : Double = 20
    
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var hAccuracy: UILabel!
    @IBOutlet weak var vAccuracy: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    var trackedEvents :[Event]!
    
    var localLocationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    func startMonitoring(event: Event) {
        if localLocationManager.monitoredRegions.count < 20 {
            makeEventRegion(localLocationManager, latitude: event._latitude, longitude: event._longitude, radius: defaultRadius, identifier: String(event._event_id))
        }
    }
    
    func untrackEvent(event: Event) {
        //takes event_id and removes it from tracked regions
    }
    
    func startLocationServices() {
        localLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        localLocationManager.delegate = self
        startLocation = nil
        requestLocationServices()
    }
    
    func requestLocationServices() {
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            localLocationManager.requestAlwaysAuthorization()
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
                localLocationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            startLocationServices()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func startWhenInUse(_ sender: Any) {
        localLocationManager.requestWhenInUseAuthorization()
        localLocationManager.startUpdatingLocation()
    }
    
    @IBAction func startAlways(_ sender: Any) {
        localLocationManager.stopUpdatingLocation()
        localLocationManager.requestAlwaysAuthorization()
        localLocationManager.startUpdatingLocation()
    }

    @IBAction func resetDistance(_ sender: Any) {
        startLocation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let latestLocation: CLLocation = locations[locations.count-1]
        
        latitude.text = String(format: "%.4f", latestLocation.coordinate.latitude)
        longitude.text = String(format: "%.4f", latestLocation.coordinate.longitude)

        if startLocation == nil {
            startLocation = latestLocation
        }
        
        let distanceBetween: CLLocationDistance = latestLocation.distance(from: startLocation)
        
        distance.text = String(format: "%.2f", distanceBetween)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print( error.localizedDescription)
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

