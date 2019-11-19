//
//  NavDetailCardViewController.swift
//  BussMeStoryboard
//
//  Created by Kevin Susanto on 18/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit

class NavDetailCardViewController: UIViewController {
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var contentArea: UIView!
    @IBOutlet weak var kodeRuteView: UIView!
    @IBOutlet weak var arahSegmentedControl: UISegmentedControl!
    @IBOutlet weak var kodeRute: UILabel!
    @IBOutlet weak var lblStop1: UILabel!
    @IBOutlet weak var lblStop2: UILabel!
    @IBOutlet weak var lblStop3: UILabel!
    @IBOutlet weak var lblStop4: UILabel!
    @IBOutlet weak var lblStop5: UILabel!
    @IBOutlet weak var lblStop6: UILabel!
    @IBOutlet weak var lblStop7: UILabel!
    @IBOutlet weak var lblStop8: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        kodeRuteView.layer.cornerRadius = 10
        
        print(arah)
        if arah == "pergi" {
            arahSegmentedControl.selectedSegmentIndex = 0
            kodeRute.text = "Breeze - ICE"
        } else if arah == "pulang" {
            arahSegmentedControl.selectedSegmentIndex = 1
            kodeRute.text = "ICE - Breeze"
        }
    }
    
    @IBAction func arahSegmentedControlAction(_ sender: Any) {
        if arahSegmentedControl.selectedSegmentIndex == 0 {
            print("pergi")
            kodeRute.text = "Breeze - ICE"
        } else {
            print("pulang")
            kodeRute.text = "ICE - Breeze"
        }
    }
    
}
