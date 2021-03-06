//
//  CommuteNaikModalViewController.swift
//  BussMeStoryboard
//
//  Created by Kevin Susanto on 22/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import CloudKit
import SystemConfiguration

class CommuteNaikModalViewController: UIViewController {
    
    @IBOutlet var handleArea: UIView!
    @IBOutlet var contentArea: UIView!
    @IBOutlet var BreezeIceView: UIView!
    
    @IBOutlet weak var lblRoute: UILabel!
    @IBOutlet weak var lblStop: UILabel!
    
    @IBOutlet weak var lblStop1: UILabel!
    @IBOutlet weak var lblStop2: UILabel!
    @IBOutlet weak var lblStop3: UILabel!
    @IBOutlet weak var lblStop4: UILabel!
    @IBOutlet weak var lblStop5: UILabel!
    @IBOutlet weak var lblStop6: UILabel!
    @IBOutlet weak var lblStop7: UILabel!
    @IBOutlet weak var lblStop8: UILabel!
    
    @IBOutlet weak var lblWaktu1: UILabel!
    @IBOutlet weak var lblWaktu2: UILabel!
    @IBOutlet weak var lblWaktu3: UILabel!
    @IBOutlet weak var lblWaktu4: UILabel!
    @IBOutlet weak var lblWaktu5: UILabel!
    @IBOutlet weak var lblWaktu6: UILabel!
    @IBOutlet weak var lblWaktu7: UILabel!
    @IBOutlet weak var lblWaktu8: UILabel!
    
    var xibDelegate: XibDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BreezeIceView.layer.cornerRadius = 15
        
        contentArea.layer.cornerRadius = 25
        contentArea.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentArea.layer.shadowOpacity = 0.1
        contentArea.layer.shadowRadius = 15
        
    }
    
//    ****** CHANGE PAGE to Alert Turun ******
    @IBAction func btnTurunBus(_ sender: Any) {
//        let nextStoryboard = UIStoryboard(name: "popUpTurun", bundle: nil)
//        let nextVC = nextStoryboard.instantiateViewController(identifier: "popUpTurunStoryboard") as popUpTurunViewController
//
//        present(nextVC, animated: true, completion: nil)
        xibDelegate?.turunBtnPressed()
    }
//    **************
}
