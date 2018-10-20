//
//  RegisterPageViewController.swift
//  UserLoginAndRegistration
//
//  Created by Jacqueline Choe on 10/20/18.
//  Copyright © 2018 G7S1. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var userConfirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        let userConfirmPassword = userConfirmPasswordTextField.text;
        
        //Check for empty fields
        if((userEmail?.isEmpty)! || (userPassword?.isEmpty)! || (userConfirmPassword?.isEmpty)!)
        {
            //Display alert message
            displayMyAlertMessage(userMessage: "All fields are required");
            
            return;
        }
        
        //Check if passwords match
        if(userPassword != userConfirmPassword)
        {
            //Display alert message
            displayMyAlertMessage(userMessage: "Passwords do not match");
            return;
        }
        
        
        //Store Data
        UserDefaults.standard.set(userEmail, forKey:"userEmail");
        UserDefaults.standard.set(userPassword, forKey:"userPassword");
        UserDefaults.standard.synchronize();
        
        //Display alert message with confirmation
        var myAlert = UIAlertController(title:"Alert", message:"Registration is successful. Thank you!", preferredStyle:UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){ action in
            self.dismiss(animated: true, completion:nil);
        }
        myAlert.addAction(okAction);
        self.present(myAlert, animated:true, completion:nil);
        
    }
      func displayMyAlertMessage(userMessage:String)
    {
        var myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle:UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated: true, completion:nil);
    
    
    }

}
