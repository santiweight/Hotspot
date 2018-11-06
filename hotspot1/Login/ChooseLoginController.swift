//
//  ChoseLoginController.swift
//  OktaPractice
//
//  Created by Zack Rossman on 10/16/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import UIKit
import OktaAuth

class ChooseLoginController: UIViewController {
    let oktaModel = OktaUserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.oktaModel.isAuthenticated() {
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.present(homeViewController, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Password requirements: at least 8 characters, a lowercase letter, an uppercase letter, a number, no parts of your username.
    
    //MARK: Action
    //login to hotspot using Okta Authentication
    @IBAction func login(_ sender: Any) {
        self.oktaModel.login(viewController: self){
            responseObject, error in
            if(responseObject!){
                //go to Hotspot home iff successful login
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.present(homeViewController, animated: true)
            }
        }
    }
}
