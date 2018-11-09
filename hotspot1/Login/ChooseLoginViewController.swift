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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if OktaModel.isAuthenticated() {
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
        OktaModel.login(viewController: self){
            responseObject, error in
            if(responseObject!){
                print("logged in")
                //go to Hotspot home iff successful login
                let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                self.navigationController?.present(mapViewController, animated: true)
            }
        }
    }
}
