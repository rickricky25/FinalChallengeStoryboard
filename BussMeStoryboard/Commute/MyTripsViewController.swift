//
//  MyTripsViewController.swift
//  BussMeStoryboard
//
//  Created by Kevin Susanto on 29/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit

class MyTripsViewController: UIViewController {

    @IBOutlet var recentTripBox: UIView!
    @IBOutlet var reminderBox: UIView!
    @IBOutlet var addNewReminder: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardSetup()
    }
    
    func cardSetup() {
        recentTripBox.layer.cornerRadius = 15
        recentTripBox.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        recentTripBox.layer.shadowRadius = 8
        recentTripBox.layer.shadowOpacity = 0.15
        recentTripBox.layer.shadowPath = UIBezierPath(rect: recentTripBox.bounds).cgPath
        recentTripBox.layer.shadowOffset = .zero
        
        reminderBox.layer.cornerRadius = 15
        reminderBox.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        reminderBox.layer.shadowRadius = 8
        reminderBox.layer.shadowOpacity = 0.15
        reminderBox.layer.shadowPath = UIBezierPath(rect: reminderBox.bounds).cgPath
        reminderBox.layer.shadowOffset = .zero
        
        addNewReminder.layer.cornerRadius = 15
        
        
    }


}
