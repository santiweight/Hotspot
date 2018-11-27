//
//  ChoseLoginController.swift
//  OktaPractice
//
//  Created by Zack Rossman on 10/16/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import UIKit
import OktaAuth

class ChooseLoginController: UIViewController{
    
    @IBOutlet var titleName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create Attachment
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named:"fire-logo")
        //Set bound to reposition
//        let imageOffsetY:CGFloat = -5.0;
//        imageAttachment.bounds = CGRect(x: 10, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
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
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if OktaModel.isAuthenticated() {
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
        OktaModel.login(viewController: self){
            responseObject, error in
            if(responseObject!){
                
                //confirm that session vars were set
                OktaModel.printSessionVars()
                
                //go to map view
                let mapViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                self.navigationController?.present(mapViewController, animated: true)
            }
        }
    }
}
