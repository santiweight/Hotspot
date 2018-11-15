//
//  CreateUserController.swift
//  OktaPractice
//
//  Created by Zack Rossman on 10/18/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import UIKit
import OktaAuth

class RegisterController: UIViewController {

    let oktaAPIKey = "00-_6NVmANndYasYRWVmXN9u4YfvY5-S7OrEhawRQC"
    var oktaModel: OktaModel!

    @IBOutlet weak var newUserName: UITextField!
    @IBOutlet weak var newUserEmail: UITextField!
    @IBOutlet weak var newUserPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
