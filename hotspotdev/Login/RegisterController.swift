//
//  CreateUserController.swift
//  OktaPractice
//
//  Created by Zack Rossman on 10/18/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import Foundation
import UIKit
import AWSCore
import AWSDynamoDB

class RegisterViewController: UIViewController  {
    
    var deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
    
    private let yearDataSource = ["Select Year", "Freshman", "Sophmore", "Junior", "Senior"]
    private let schoolDataSource = ["Select School", "Claremont Mckenna", "Pomona", "Scripss", "Harvey Mudd", "Pitzer"]

    @IBOutlet weak var newUserName: UITextField!
    @IBOutlet weak var newUserEmail: UITextField!
    @IBOutlet weak var newUserPassword: UITextField!
    @IBOutlet weak var newUserConfirmPassword: UITextField!
    
    @IBOutlet weak var schoolPickerView: UIPickerView!
    @IBOutlet weak var selectSchool: UILabel!
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var selectYear: UILabel!
    
    var schoolOutput : String = ""
    var yearOutput : String = ""
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        yearPickerView.dataSource = self
        yearPickerView.delegate = self
        yearPickerView.tag = 1
        
        schoolPickerView.dataSource = self
        schoolPickerView.delegate = self
        schoolPickerView.tag = 2
    }
    
    //create an active user in Okta group, direct to login page
    @IBAction func submit(_ sender: Any) {
        OktaManager.shared.createUser(params: constructRequest()){
            responseObject, error in
                if(responseObject!){
                    
                    //alert tells user that user was succesfully created
                    let userCreatedAlert = UIAlertController(title: "Successfully Created User", message: "", preferredStyle: .alert)
                    userCreatedAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {
                        action in
                            let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                            self.navigationController?.present(mapViewController, animated: true)
                    }))
                    self.present(userCreatedAlert, animated: true)
                }else{
                    //alert prompts user to edit registration info
                    let userErrorAlert = UIAlertController(title: "Error Creating User", message: "", preferredStyle: .alert)
                    userErrorAlert.addAction(UIAlertAction(title: "Edit Info", style: .cancel, handler: nil))
                    self.present(userErrorAlert, animated: true)
            }
        }
    }
    
    //construct a dictionary used for Okta API request
    func constructRequest() -> [String: Any]{
        //store in "lastName" and "mobilePhone" fields
        let userYear = yearDataSource[yearPickerView.selectedRow(inComponent: 0)]
        let userSchool = schoolDataSource[schoolPickerView.selectedRow(inComponent: 0)]
        let requestBody: [String: Any] = [
            "profile": [
                "firstName": "\(userYear)",
                "lastName": "\(userSchool)",
                "email": "\(newUserEmail.text ?? "")",
                "login": "\(newUserEmail.text ?? "")",
                "mobilePhone": "425-241-7707"
            ],
            "credentials": [
                "recovery_question": [
                    "question": "What's your mother's maiden name?",
                    "answer": "Hoisington"
                ],
                "password" : [ "value": "\(newUserPassword.text ?? "")" ]
            ]
        ]
        return requestBody
    }
}

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == schoolPickerView {
            //pickerView1
            return schoolDataSource.count
        } else if pickerView == yearPickerView{
            //pickerView2
            return yearDataSource.count
        }
        return 1
   }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == yearPickerView{
            //pickerView1
            //return yearDataSource.count
        } else if pickerView == schoolPickerView{
            //return schoolDataSource.count
        }
    return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView == schoolPickerView {
            //pickerView1
            schoolOutput = schoolDataSource[row]
        } else if pickerView == yearPickerView{
            //pickerView2
            yearOutput = yearDataSource[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if pickerView == schoolPickerView {
            //pickerView1
            return schoolDataSource[row]
        } else if pickerView == yearPickerView{
            //pickerView2
            return yearDataSource[row]
        }
        return "ERROR"
    }
}

