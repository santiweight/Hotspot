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

    
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventAddress: UITextField!
    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var expectedPeople: UITextField!
    
    @IBOutlet weak var selectSchool: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
    
    @IBOutlet weak var pickerData: UIDatePicker!
    @IBOutlet weak var endPickerData: UIDatePicker!
    
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
    }
    
    func getDateString(pickerData: UIDatePicker) -> String{
        //get day/month/year info from picker
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        let dateString = dateFormatter.string(from: pickerData.date)
        
        //get time info from picker
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: pickerData.date)
        let hour = comp.hour
        let minute = comp.minute
        let timeString = "\(hour!):\(minute!),"
        
        let completeString = "\(timeString) \(dateString)"
        
        print(completeString)
        return completeString
    }
    
    @IBAction func submit(_ sender: Any) {
        getDateString(pickerData: pickerData)
        getDateString(pickerData: endPickerData)
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
                    
                    let startComponents = DateComponents()

                    
                    let endComponents = DateComponents()

                    

                    let newEvent = Event(creator_email: "zackrossman10@gmail.com", title: self.eventTitle.text!, address: formattedAddress, description: self.eventDescription.text!, start: startComponents, end: endComponents, attendees: ["zackrossman10@gmail.com"], expectedAttendees: 5, latitude: latitude, longitude: longitude, year_filters: [self.selectSchool.text!], school_filters: ["CMC"])


                    
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

