//
//  CreateEventViewController.swift
//  hotspot1
//
//  Created by Zack Rossman on 10/26/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import Foundation
import UIKit

class CreateEventViewController: UIViewController {
    
    //Obj for making API calls to Google Geocoder
    var geocoder = Geocoder()
    
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventAddress: UITextField!
    @IBOutlet weak var eventDescription: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createEvent(_ sender: Any) {
        geocoder.getLocation(address: eventAddress.text!){
            responseObject, error in
            if(responseObject != nil && !(responseObject?.isEmpty)!){
                let formattedAddress = responseObject!.formattedAddress!
                let addressConfirmAlert = UIAlertController(title: "Confirm Event Address", message: "\(formattedAddress)", preferredStyle: .alert)
                addressConfirmAlert.addAction(UIAlertAction(title: "Edit", style: .cancel, handler: {action in
                        print("Address edited")
                    }))
                addressConfirmAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {
                        action in
                    
                    let latitude = responseObject!.latitude!
                    let longitude = responseObject!.longitude!
                    
                    var startComponents = DateComponents()
                    startComponents.year = 2018
                    startComponents.month = 12
                    startComponents.day = 10
                    startComponents.month = 2
                    startComponents.minute = 30
                    
                    var endComponents = DateComponents()
                    endComponents.year = 2019
                    endComponents.month = 12
                    endComponents.day = 10
                    endComponents.month = 2
                    endComponents.minute = 30
                    
                    var newEvent = Event(event_id: 1, creator_email: "zackrossman10@gmail.com", title: self.eventTitle.text!, address: formattedAddress, description: self.eventDescription.text!, start: startComponents, end: endComponents, attendees: ["zackrossman10@gmail.com"], expectedAttendees: 5, latitude: latitude, longitude: longitude, filters: [1])
                    
                    print("New event created")
                    //insert into db
                    
                    //call segue back to home page/event page
                    
                }))
                
                self.present(addressConfirmAlert, animated: true)
            }else{
                print("Response obj is nil")
                let badAddressAlert = UIAlertController(title: "Address Not Found", message: "Please enter the approximate address for your event", preferredStyle: .alert)
                badAddressAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(badAddressAlert, animated: true)
            }
        }
    }
}



