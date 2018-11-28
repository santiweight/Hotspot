//
//  CreateEventViewController.swift
//  hotspot1
//
//  Created by Zack Rossman on 10/26/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import Foundation
import UIKit
import AWSCore
import AWSDynamoDB


@objc protocol SSRadioButtonControllerDelegate {
@objc func didSelectButton(selectedButton: UIButton?)
}

class CreateEventViewController: UIViewController {
    
    let localCalendar = Calendar.init(identifier: .gregorian)
    let calComponents : Set<Calendar.Component> = [.year, .month, .day, .hour]
    
    let YEAR = TimeInterval.init(31536000)
    let HOUR = TimeInterval.init(3600)
    
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventAddress: UITextField!
    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var selectSchool: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
    

    @IBOutlet weak var pickerLabel: UILabel!
    @IBOutlet weak var endPickerLabel: UILabel!
    

    @IBOutlet weak var startPicker: UIDatePicker!
    @IBOutlet weak var endPicker: UIDatePicker!
    
    
    var db = DatabaseController()
    var geocoder = Geocoder()
 
    @IBAction func cmcCheckTapped(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }
        else{
            sender.isSelected = true
        }
    }


    @IBAction func poCheckTapped(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }
        else{
            sender.isSelected = true
        }
    }
    
    @IBAction func scrCheckTapped(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }
        else{
            sender.isSelected = true
        }
    }
    
    
 
    @IBAction func hmcCheckTapped(_ sender: UIButton) {
    if sender.isSelected{
            sender.isSelected = false
        }
        else{
            sender.isSelected = true
        }
    }
    
    @IBAction func pzCheckTapped(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }
        else{
            sender.isSelected = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setPickers()
    }
    
    func setPickers() {
        let currentTime = Date.init()
        
        startPicker.minimumDate = currentTime
        startPicker.maximumDate = currentTime.addingTimeInterval(YEAR)
        
        endPicker.minimumDate = currentTime.addingTimeInterval(HOUR)
        endPicker.maximumDate = currentTime.addingTimeInterval(YEAR)
        
    }
    
    @IBAction func submit(_ sender: Any) {
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
                    
                    let startDateComps = self.localCalendar.dateComponents(_: self.calComponents, from: self.startPicker.date)
                    let endDateComps = self.localCalendar.dateComponents(_: self.calComponents, from: self.endPicker.date)

                    
                    let newEvent = Event(user_id: self.deviceID, creator_email: "zackrossman10@gmail.com", title: self.eventTitle.text!, address: formattedAddress, description: self.eventDescription.text!, start: startDateComps, end: endDateComps, attendees: ["zackrossman10@gmail.com"], expectedAttendees: 5, latitude: latitude, longitude: longitude, year_filters: [self.selectSchool.text!], school_filters: ["CMC"])

                    
                    print("New event created")
                    //insert into db
                    self.db.updateEventDb(event: newEvent)
                    let uploadConfirmAlert = UIAlertController(title: "Successfully Created Event", message: "", preferredStyle: .alert)
                    uploadConfirmAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {
                        action in
                        let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                        self.navigationController?.present(mapViewController, animated: true)
                    }))
                    self.present(uploadConfirmAlert, animated: true)
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

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

