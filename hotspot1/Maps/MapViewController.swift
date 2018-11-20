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
    
//    var coordinates: [[Double]]!
//    var names:[String]!
//    var hotness:[String]!
//    var add:[String]!
//    var time:[String]!
//    var id2:[String]!
    
    @IBOutlet var mapView: MKMapView!
  
    //var db = DatabaseController()
    
    override func viewDidLoad() {
        
        //let eventsList = db.eventIdQuery(eventTitle: <#T##String#>)
        
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        //addEventToMap()

        // 3
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.0944, longitude: -117.7083), span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
        self.mapView.setRegion(region, animated: true)
    }
    
    func addEventToMap(newEvent: Event){
        
        let calendar = Calendar.current
        
//        var startComponents = DateComponents()
//        startComponents.year = 2018
//        startComponents.day = 10
//        startComponents.month = 2
//        startComponents.minute = 30
//
//        var endComponents = DateComponents()
//        endComponents.year = 2019
//        endComponents.month = 11
//        endComponents.day = 9
//        endComponents.minute = 29
//
//        var newEvent = Event(event_id: 1, user_id: "1", creator_email: "zackrossman10@gmail.com", title: "Dodgeball", address: "3927 Old Pali Road", description: "come throw some balls at one another", start: startComponents, end: endComponents, attendees: ["zackrossman10@gmail.com"], expectedAttendees: 5, latitude: 34.0944, longitude: -117.7083, year_filters: ["CMC"], school_filters: ["CMC"])
        
        //instantiate a new EventAnnotation and set its values to the event parameter
        let point = EventAnnotation(coordinate: CLLocationCoordinate2D(latitude: newEvent._latitude , longitude: newEvent._longitude ))
        point.name = newEvent._title
        point.add = newEvent._address
        point.hotness = String(describing: newEvent._attendees.count)
        point.id2 = String(describing: newEvent._event_id)
        
        // convert component to date
        let sDate = calendar.date(from: newEvent._start)
        let eDate = calendar.date(from: newEvent._end)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM H:mm"
        
        // convert date to string
        let sString = dateFormatter.string(from: sDate!)
        let eString = dateFormatter.string(from: eDate!)
        
        point.time = eString + " - " + sString
        
        // adding event point to map
        self.mapView.addAnnotation(point)
        
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
        var id2: String
        let ccv = sender.superview as! CustomCalloutView
        
        id2 = ccv.eventID.text!
        name = ccv.eventName.text!
        
        //print("clicked: " + name)
        
        // instantiate a version of the eventVC
        let eventViewController = self.storyboard?.instantiateViewController(withIdentifier: "EventViewController") as! EventViewController
        
        // pass data from mapVC to eventVC
        eventViewController.name = name
        eventViewController.id2 = id2
        
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
