//
//  ViewController.swift
//  CustomCalloutView
//
//  Created by Malek T. on 3/9/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//
import UIKit
import MapKit
import AWSCore
import AWSDynamoDB

class MapViewController: UIViewController, MKMapViewDelegate {
    
//    var coordinates: [[Double]]!
//    var names:[String]!
//    var hotness:[String]!
//    var add:[String]!
//    var time:[String]!
//    var id2:[String]!
    
    
    
    @IBOutlet var mapView: MKMapView!
    
    func getEvents(indexType: String, indexVal: String){
        
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 50
        let om = AWSDynamoDBObjectMapper.default()
        
        if(indexType != "ALL"){
            scanExpression.filterExpression = indexType + " = :val"
            scanExpression.expressionAttributeValues = [":val": indexVal]
        }
        
        om.scan(EventTable.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            }
            else if let paginatedOutput = task.result {
                for event in paginatedOutput.items as! [EventTable] {
                    let userEvent = Event()
                    userEvent.queryObjToUserEvent(qObj: event)
                    
                    userEvent._latitude = event._latitude as? Double
                    userEvent._longitude = event._longitude as? Double
                    
                    self.addEventToMap(newEvent: userEvent)
                
                }
            }
            return nil
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self

        // declare the region of the map to show the claremont colleges
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.0944, longitude: -117.7083), span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
        
        // set the claremont region to the map
        self.mapView.setRegion(region, animated: true)
        
        // call get events to query and add each event in DB to the map
        getEvents(indexType: "ALL", indexVal: "ALL")
        
    }
    
    func addEventToMap(newEvent: Event){
        
        let calendar = Calendar.current
        
        // check if new event has nil lat or longs, if it does, dont plot it
        if (newEvent._longitude != nil && newEvent._latitude != nil){
            
            // declare a new point on the map to inherit ethe EventAnnotation Class
            let point = EventAnnotation(coordinate: CLLocationCoordinate2D(latitude: newEvent._latitude , longitude: newEvent._longitude ))
            
            // set values of the point to the newEvent values that was passed in
            point.name = newEvent._title
            point.add = newEvent._address
            point.hotness = String(describing: newEvent._attendees.count)
            point.id2 = String(describing: newEvent._event_id)
            
            // convert component to date
            let sDate = newEvent._start!
            let eDate = newEvent._end!
            
            point.time = sDate + " - " + eDate
            
            // add the point to the map
            self.mapView.addAnnotation(point)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func increaseAttendance(sender: UIButton)
    {
        print("clicked: attendance")
    }
    
    // MARK - Action Handler
    @objc func redirectToEvent(sender: UIButton)
    {
        // get data from view controller
        var name: String
        var time: String
        let ccv = sender.superview as! CustomCalloutView
        
        name = ccv.eventName.text!
        time = ccv.eventTime.text!
        
        
        // instantiate a version of the eventVC
        let eventViewController = self.storyboard?.instantiateViewController(withIdentifier: "EventViewController") as! EventViewController
        
        // pass data from mapVC to eventVC
        eventViewController.name = name
        eventViewController.time = time

        
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
        annotationView?.image = UIImage(named: "fire-logo")
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
        calloutView.eventID.text = eventAnnotation.id2
        
        let infoButton = UIButton(frame: calloutView.infoButtonLabel.frame)
        let attendButton = UIButton(frame: calloutView.attendButton.frame)

        
        infoButton.addTarget(self, action: #selector(MapViewController.redirectToEvent(sender:)), for: .touchUpInside)
        calloutView.addSubview(infoButton)
        
        attendButton.addTarget(self, action: #selector(MapViewController.increaseAttendance(sender:)), for: .touchUpInside)
        calloutView.addSubview(attendButton)
        
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
