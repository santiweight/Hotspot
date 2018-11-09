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
    var add:[String]!
    var time:[String]!
    
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
        coordinates = [[34.0944,-117.7083],[34.0600,-117.7033]]// Latitude,Longitude
        names = ["Test1","Tes2"]
        hotness = ["3", "4"]
        add = ["adresssss","adresssss"]
        time = ["10pm","3pm"]
        
        // 2
        for i in 0...1
        {
            let coordinate = coordinates[i]
            let point = EventAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinate[0] , longitude: coordinate[1] ))
            point.name = names[i]
            point.add = add[i]
            point.hotness = hotness[i]
            point.time = time[i]
            
            self.mapView.addAnnotation(point)
        }

        // 3
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.0944, longitude: -117.7083), span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
        self.mapView.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Action Handler
    @objc func redirectToEvent(sender: UIButton)
    {
        // get data from view controller
        var name: String
        let v = sender.superview as! CustomCalloutView
        name = v.eventName.text!
        
        //print("clicked: " + name)
        
        // instantiate a version of the eventVC
        let eventViewController = self.storyboard?.instantiateViewController(withIdentifier: "EventViewController") as! EventViewController
        
        // pass data from mapVC to eventVC
        eventViewController.text = name
        
        // Switch over to the eventVC
        self.present(eventViewController, animated: true, completion: nil)
        
        
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
        
        // set each variable in the calloutview to its corresponding ones in annotation
        calloutView.eventName.text = eventAnnotation.name
        calloutView.eventAddress.text = eventAnnotation.add
        calloutView.eventHotness.text = "Hotness = " + eventAnnotation.hotness
        calloutView.eventTime.text = eventAnnotation.time
        
        let button = UIButton(frame: calloutView.infoButtonLabel.frame)
        
        button.addTarget(self, action: #selector(MapViewController.redirectToEvent(sender:)), for: .touchUpInside)
        calloutView.addSubview(button)
        
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
