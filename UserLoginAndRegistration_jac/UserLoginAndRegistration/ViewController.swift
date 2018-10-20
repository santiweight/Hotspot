//
//  ViewController.swift
//  UserLoginAndRegistration
//
//  Created by Jacqueline Choe on 10/20/18.
//  Copyright © 2018 G7S1. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool){
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn");
        
        if(!isUserLoggedIn)
        {
            self.performSegue(withIdentifier: "loginView", sender: self);
            
        }
        self.performSegue(withIdentifier: "loginView", sender: self);
    }

    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey:"isUserLoggedIn");
        UserDefaults.standard.synchronize();
        self.performSegue(withIdentifier: "loginView", sender: self);
    }
    
}

