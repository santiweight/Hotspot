//
//  EventViewController.swift
//  hotspot1
//
//  Created by Ethan Lloyd Lewis on 11/5/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    var name: String? = ""
    var id2: String? = ""
    

    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        test?.text = name
        idLabel?.text = id2
    }
    

}
