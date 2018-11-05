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

        //create & activate user in Okta group, direct to login page
        oktaModel = OktaUserModel()
        if oktaModel.createUser(APIKey: oktaAPIKey, params: requestBody){
            oktaModel.login(viewController: self)
        }
    }
}
