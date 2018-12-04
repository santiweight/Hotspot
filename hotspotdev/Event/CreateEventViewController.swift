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

class CreateEventViewController: UIViewController {

    var deviceID = (UIDevice.current.identifierForVendor?.uuidString)!

    let localCalendar = Calendar.init(identifier: .gregorian)
    let calComponents : Set<Calendar.Component> = [.year, .month, .day, .hour]

    let YEAR = TimeInterval.init(31536000)
    let HOUR = TimeInterval.init(3600)

    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventAddress: UITextField!
    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var expectedPeople: UITextField!
    @IBOutlet weak var startPicker: UIDatePicker!
    @IBOutlet weak var endPicker: UIDatePicker!

    var selectSchool : [String] = []
    @IBOutlet weak var detailLabel: UILabel!

    var db = DatabaseController()

    @IBAction func cmcCheckTapped(_ sender: UIButton) {
        if sender.isSelected{
            selectSchool = selectSchool.filter {$0 != "CMC"}
            sender.isSelected = false
        }
        else{
            selectSchool.append("CMC")
            sender.isSelected = true
        }
    }

    @IBAction func poCheckTapped(_ sender: UIButton) {
        if sender.isSelected{
            selectSchool = selectSchool.filter {$0 != "POM"}
            sender.isSelected = false
        }
        else{
            selectSchool.append("POM")
                sender.isSelected = true
        }
    }

    @IBAction func scrCheckTapped(_ sender: UIButton) {
        if sender.isSelected{
            selectSchool = selectSchool.filter {$0 != "SCR"}
            sender.isSelected = false
        }
        else{
            selectSchool.append("SCR")
                sender.isSelected = true
        }
    }

    @IBAction func hmcCheckTapped(_ sender: UIButton) {
        if sender.isSelected{
            selectSchool = selectSchool.filter {$0 != "HMC"}
            sender.isSelected = false
        }
        else{
            selectSchool.append("HMC")
                sender.isSelected = true
        }
    }

    @IBAction func pzCheckTapped(_ sender: UIButton) {
        if sender.isSelected{
            selectSchool = selectSchool.filter {$0 != "PIZ"}
            sender.isSelected = false
        }
        else{
            selectSchool.append("PIZ")
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
        Geocoder.shared.getLocation(address: eventAddress.text ?? ""){
            responseObject, error in
            if(responseObject != nil && !(responseObject?.isEmpty)!){
                let formattedAddress = responseObject!.formattedAddress!
                let addressConfirmAlert = UIAlertController(title: "Confirm Event Address", message: "\(formattedAddress)", preferredStyle: .alert)
                addressConfirmAlert.addAction(UIAlertAction(title: "Edit", style: .cancel, handler: {action in
                        print("Address edited")
                    }))
                addressConfirmAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {
                        action in
                    let newEvent = Event(
                        user_id: self.deviceID,
                        event_id: "NULL",
                        address: formattedAddress,
                        atEvent: ["NULL"],
                        attendees: [OktaManager.shared.getSessionInfo()["sessionEmail"] ?? ""],
                        description: self.eventDescription.text ?? "",
                        endTime: getDateString(pickerData: self.endPicker),
                        startTime: getDateString(pickerData: self.startPicker),
                        expectedAttencence: Int(self.expectedPeople.text ?? "0") ?? 0,
                        latitude: responseObject!.latitude!,
                        longitude: responseObject!.longitude!,
                        school: "CMC",
                        title: self.eventTitle.text ?? "",
                        userEmail: OktaManager.shared.getSessionInfo()["sessionEmail"] ?? "",
                        year: 0)
                    
                    print("New event created")
                    stringToDateComponent(stringDate: getDateString(pickerData: self.endPicker))
                    //insert into db
//                    self.db.updateEventDb(event: newEvent)
//
//                    let uploadConfirmAlert = UIAlertController(title: "Successfully Created Event", message: "", preferredStyle: .alert)
//                    uploadConfirmAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {
//                        action in
//                        let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//                        self.navigationController?.present(mapViewController, animated: true)
//                    }))
//                    self.present(uploadConfirmAlert, animated: true)
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
    
    func checkDatesValid(start: DateComponents, end: DateComponents) -> Bool{
        let startDate = localCalendar.date(from: start)
        let endDate = localCalendar.date(from: end)
        let dateComp = localCalendar.compare(startDate!, to: endDate!, toGranularity: Calendar.Component.minute)

        if (dateComp == ComparisonResult.orderedAscending){
            return true
        } else if (dateComp == ComparisonResult.orderedSame){
            let sameTimeAlert = UIAlertController(title: "Date Picker Error", message: "An event's start and end time must be different", preferredStyle: .alert)
            sameTimeAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(sameTimeAlert, animated: true)
            return false
        } else if (dateComp == ComparisonResult.orderedAscending) {
            let endDateFirstAlert = UIAlertController(title: "Date Picker Error", message: "An event's start time must come before its end time", preferredStyle: .alert)
            endDateFirstAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(endDateFirstAlert, animated: true)
            return false
        }
        return false
    }
}

//get date info as a string from date picker
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

//func getDateString(pickerData: UIDatePicker) -> DateComponents{
//    var dc = DateComponents()
//    let calendar = Calendar.current
//    let bigComponents = calendar.dateComponents([.day,.month,.year], from: pickerData.date)
//    dc.year = bigComponents.year
//    dc.month = bigComponents.month
//    dc.day = bigComponents.day
//
//    //get time info from picker
//    let smallComponents = calendar.dateComponents([.hour, .minute], from: pickerData.date)
//    dc.hour = smallComponents.hour
//    dc.minute = smallComponents.minute
//    return dc
//}

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
