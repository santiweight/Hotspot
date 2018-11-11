CC//
//  ViewController.swift
//  HotspotLocationManager
//
//  Created by cs121 on 11/4/18.
//  Copyright © 2018 cs121. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        localLocationManager.delegate = self
        startLocation = nil
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
        vAccuracy.text = String(format: "%.4f", latestLocation.verticalAccuracy)
        hAccuracy.text = String(format: "%.4f", latestLocation.horizontalAccuracy)
        Altitude.text = String(format: "%.4f", latestLocation.altitude)

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
        //TODO Check specific location authorization
        
    }
    
    /*func locationManager(_ manager: CLLocationManager, latitude: Double, longitude: Double, identifier: String) {
        self.locationManager(latitude: latitude, longitude: latitude, radius: defaultRadius, identifier: identifier)
    }
    
    func locationManager(_ manager: CLLocationManager, latitude: Double, longitude: Double, radius: Double, identifier: String) {
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: radius, identifier: identifier )
        manager.startMonitoring(for: region)
    }
    JUST REALISED THIS SHOULD ALL GO IN THE EVENTMANAGER CLASS
     */
}

