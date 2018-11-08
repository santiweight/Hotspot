//
//  EventViewController.swift
//  hotspot1
//
//  Created by Ethan Lloyd Lewis on 11/5/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    var text: String? = ""
    

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var test: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        test?.text = text
    }
    

}
