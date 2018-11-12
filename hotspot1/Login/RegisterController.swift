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
    var oktaModel: OktaUserModel!
    @IBOutlet weak var newUserName: UITextField!
    @IBOutlet weak var newUserEmail: UITextField!
    @IBOutlet weak var newUserPswd: UITextField!
    @IBOutlet weak var newUserSchool: UITextField!
    @IBOutlet weak var newUserYear: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func completionHandler(value: Bool) {
        print("Function completion handler value: )")
    }
    
        //MARK: Action
    @IBAction func Register(_ sender: Any) {
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
                "password" : [ "value": "\(newUserPswd.text ?? "")" ]
            ]
        ]

        //create an active user in Okta group, direct to login page
        oktaModel = OktaUserModel()
        oktaModel.createUser(APIKey: oktaAPIKey, params: requestBody){
            responseObject, error in
                if(responseObject!){
                    let userCreatedAlert = UIAlertController(title: "Successfully Created User", message: "", preferredStyle: .alert)
                    userCreatedAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {
                        action in
                            let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                            self.navigationController?.present(mapViewController, animated: true)
                    }))
                    self.present(userCreatedAlert, animated: true)
                }else{
                    let userErrorAlert = UIAlertController(title: "Error Creating User", message: "\(error ?? "" as! Error)", preferredStyle: .alert)
                    userErrorAlert.addAction(UIAlertAction(title: "Edit Info", style: .cancel, handler: nil))
                    self.present(userErrorAlert, animated: true)
                }
        }
    }
}