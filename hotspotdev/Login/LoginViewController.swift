//
//  ChoseLoginController.swift
//  OktaPractice
//
//  Created by Zack Rossman on 10/16/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import UIKit
import OktaAuth

class LoginViewController: UIViewController{
    
    @IBOutlet var titleName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create Attachment
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named:"fire-logo")
        //Create string with attachment
        let attachmentString = NSMutableAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        //Add image to mutable string
        let textAfterIcon = NSMutableAttributedString(string: "tspot")
        attachmentString.append(textAfterIcon)
        completeText.append(attachmentString)
        //Add your text to mutable string
        let textBeforeIcon = NSMutableAttributedString(string: "H")
        textBeforeIcon.append(completeText)
        //completeText.append(textAfterIcon)
        self.titleName.textAlignment = .center;
        self.titleName.attributedText = textBeforeIcon;
        
        EventManager.initializeLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Lauch screen Testing Grounds
        
        if OktaManager.shared.isAuthenticated() {
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            self.navigationController?.present(homeViewController, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    //login to hotspot using Okta Authentication
    @IBAction func login(_ sender: Any) {
        OktaManager.shared.login(viewController: self){
            responseObject, error in
            if(responseObject!){
                
                //confirm that session vars were set
                OktaManager.shared.getSessionInfo()
                
                //go to map view
                let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                let navigationController = UINavigationController(rootViewController: mapViewController)
                self.present(navigationController, animated: true)
            }
        }
    }
}
