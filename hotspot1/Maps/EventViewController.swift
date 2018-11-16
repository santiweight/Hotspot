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
    
    var address: String? = "3920 Old Pali Road"
    var time: String? = "10:00 AM - 11:00 AM"
    var desc: String? = "Play date with the pugs, all are welcome"
    var host: String? = "elewis20@stuents.claremontmckenna.edu"
    
    

    @IBOutlet weak var backButton: UIButton!
    
    // test = name
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // attempting to set border around tittle of event
        // test.layer.borderColor = UIColor.orange.cgColor
        
        
        test?.text = name
        idLabel?.text = id2
        
        // querery database for rest of info.
        descLabel?.text = desc
        addressLabel?.text = address
        hostLabel?.text =  host
        timeLabel?.text = time
    }
    

}
