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

class RegisterController: UIViewController  {
    
    private let yearDataSource = ["Select Year", "Freshman", "Sophmore", "Junior", "Senior"]
    private let schoolDataSource = ["Select School", "CMC", "PO", "SCR", "HMC", "PZ"]

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
    
    
     var deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearPickerView.dataSource = self
        yearPickerView.delegate = self
        yearPickerView.tag = 1
        
        schoolPickerView.dataSource = self
        schoolPickerView.delegate = self
        schoolPickerView.tag = 2
    }
    
    func completionHandler(value: Bool) {
        print("Function completion handler value: )")
    }
    
        //MARK: Action
    @IBAction func submit(_ sender: Any) {
        let requestBody: [String: Any] = [
            "profile": [
                "firstName": "\(newUserName.text ?? "")",
                "lastName": "\(newUserName.text ?? "")",
                "email": "\(newUserEmail.text ?? "")",
                "login": "\(newUserEmail.text ?? "")",
                "mobilePhone": "555-415-1337"
            ],
            "credentials": [
                "recovery_question": [
                    "question": "What's your mother's maiden name?",
                    "answer": "Hoisington"
                ],
                "password" : [ "value": "\(newUserPassword.text ?? "")" ]
            ]
        ]
        

        //create an active user in Okta group, direct to login page
        OktaModel.createUser(params: requestBody){
            responseObject, error in
                if(responseObject!){
                    
                    //access session email
                    let sessionEmail = UserDefaults.standard.object(forKey: "sessionEmail") as! String
                    print("Logged in: \(sessionEmail)")
                    
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
}

extension RegisterController: UIPickerViewDelegate, UIPickerViewDataSource{
    
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
    
    //school
    
    /*func schoolPickerView(_ schoolPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == schoolPickerView {
            //pickerView1
        } else if pickerView == yearPickerView{
            //pickerView2
        }
        return schoolDataSource.count
    }

    
    func schoolNumberOfComponents(in schoolPickerView: UIPickerView) -> Int {
        return 1
    }
    
    func schoolPickerView(_ schoolPickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
    }
    
    
    
    func schoolPickerView(_ schoolPickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return schoolDataSource[row]
    } */
    
    
    
    
}

