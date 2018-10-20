//
//  LoginViewController.swift
//  UserLoginAndRegistration
//
//  Created by Jacqueline Choe on 10/20/18.
//  Copyright © 2018 G7S1. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        
        let userEmailStored = UserDefaults.standard.string(forKey: "userEmail");
        let userPasswordStored = UserDefaults.standard.string(forKey: "userPassword");
        if(userEmailStored == userEmail){
            if(userPasswordStored == userPassword)
            {


                //Login is successfull
                UserDefaults.standard.set(true, forKey:"isUserLoggedIn");
                UserDefaults.standard.synchronize();
                self.dismiss(animated: true, completion:nil);
            }
        }
        
    }
    
 
}
