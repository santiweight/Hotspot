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
    //private let dataSource = ["Select School", "CMC", "PO", "SCR", "HMC", "PZ"]
    
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventAddress: UITextField!
    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var selectSchool: UILabel!
    //@IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var detailLabel: UILabel!
    
    var deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
    

    @IBOutlet weak var pickerLabel: UILabel!
    @IBOutlet weak var endPickerLabel: UILabel!
    
    @IBOutlet weak var pickerData: UIDatePicker!
    

    @IBOutlet weak var endPickerData: UIDatePicker!
    


    //
    var db = DatabaseController()

    
    @IBAction func selectData(_ sender: Any) {
        
        pickerLabel.text = "\(pickerData.date)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pickerView.dataSource = self
        //pickerView.delegate = self
        
        
        
    }
    
    @IBAction func submit(_ sender: Any) {
        Geocoder.getLocation(address: eventAddress.text!){
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
                    
                    var newEvent = Event(user_id: self.deviceID, creator_email: "zackrossman10@gmail.com", title: self.eventTitle.text!, address: formattedAddress, description: self.eventDescription.text!, start: startComponents, end: endComponents, attendees: ["zackrossman10@gmail.com"], expectedAttendees: 5, latitude: latitude, longitude: longitude, year_filters: [self.selectSchool.text!], school_filters: ["CMC"])

                    
                    print("New event created")
                    //insert into db
                    self.db.updateEventDb(event: newEvent)
                    self.db.eventIdQuery(eventTitle: "hi")
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

/*extension CreateEventViewController: UIPickerViewDelegate, UIPickerViewDataSource{
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return dataSource.count
        }
        
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        }
        
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return dataSource[row]
        }
 }
 */

