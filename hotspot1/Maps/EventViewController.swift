//
//  EventViewController.swift
//  hotspot1
//
//  Created by Ethan Lloyd Lewis on 11/5/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    var name = ""
    var id2 = ""
    
    var address = ""
    var time = ""
    var desc = ""
    var host = ""
    
    

    @IBOutlet weak var backButton: UIButton!

    
    // test = name

    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    
    let db = DatabaseController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // attempting to set border around tittle of event
        // test.layer.borderColor = UIColor.orange.cgColor
        
        
        test?.text = name
        idLabel?.text = id2
        
        // let event: Event = db.eventIdQuery(eventTitle: name)
        
        
        // querery database for rest of info.
        descLabel?.text = desc
        addressLabel?.text = address
        hostLabel?.text =  host
        timeLabel?.text = time
    }
    

}
