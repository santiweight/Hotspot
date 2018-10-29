//
//  ViewController.swift
//  CustomCalloutView
//
//  Created by Malek T. on 3/9/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var coordinates: [[Double]]!
    var names:[String]!
    var hotness:[String]!
    var desc:[String]!
    
    @IBOutlet var mapView: MKMapView!
    
    
    //    let regionRadius: CLLocationDistance = 1000
    //    func centerMapOnLocation(location: CLLocation) {
    //        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
    //                                                                  regionRadius, regionRadius)
    //    mapView.setRegion(coordinateRegion, animated: true)
    
    //}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        
        // 1
        coordinates = [[21.283921,-157.831661],[21.273921,-157.821661]]// Latitude,Longitude
        names = ["Test1","Tes2"]
        hotness = ["3", "4"]
        desc = ["Fun time! Soccer!","Polo match! Starts at 10:00"]
        
        
        
        // 2
        for i in 0...1
        {
            let coordinate = coordinates[i]
            let point = EventAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinate[0] , longitude: coordinate[1] ))
            point.name = names[i]
            point.desc = desc[i]
            point.hotness = hotness[i]
            
            self.mapView.addAnnotation(point)
        }
        //        // set initial location in Honolulu
        //          let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        //        //  let initialLocation = CLLocation(latitude: 34.1018, longitude: -117.7079)
        //        centerMapOnLocation(location: initialLocation)
        // 3
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 21.282778, longitude: -157.829444), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.mapView.setRegion(region, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

typealias MapViewDelegate = MapViewController
extension MapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "starbucks")
        return annotationView
    }
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        // 1
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        // 2
        let eventAnnotation = view.annotation as! EventAnnotation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.eventName.text = eventAnnotation.name
        calloutView.eventDesc.text = eventAnnotation.desc
        calloutView.eventHotness.text = eventAnnotation.hotness
        //        calloutView.starbucksImage.image = starbucksAnnotation.image
        //        let button = UIButton(frame: calloutView.starbucksPhone.frame)
        //        button.addTarget(self, action: #selector(ViewController.callPhoneNumber(sender:)), for: .touchUpInside)
        //        calloutView.addSubview(button)
        // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
}
