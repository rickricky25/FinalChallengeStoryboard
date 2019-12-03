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
    
    // pop up visual effect
    @IBOutlet var popUpView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var effect: UIVisualEffectView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.visualEffectView.isHidden = true
        
        popUpView.layer.cornerRadius = 15
        
        //BreezeIceView.layer.cornerRadius = 15
        
        //contentArea.layer.cornerRadius = 25
        //contentArea.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //contentArea.layer.shadowOpacity = 0.1
        //contentArea.layer.shadowRadius = 15
        
    }
    
    func animateIn() {
        self.view.addSubview(popUpView)
        popUpView.center = self.view.center
        popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUpView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.isHidden = false
            self.popUpView.alpha = 1
            self.visualEffectView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
        }
        
    }
    
    func animateOut() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.popUpView.alpha = 0
            self.visualEffectView.alpha = 0
            
            
        }) { (success:Bool) in
            self.popUpView.removeFromSuperview()
            self.visualEffectView.isHidden = true
            
        }
        
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        
        animateOut()
        
    }
    @IBAction func btnTurn(_ sender: Any) {
        
        animateIn()
        
    }
    
//    ****** CHANGE PAGE to Alert Turun ******
    @IBAction func btnTurunBus(_ sender: Any) {
        let nextStoryboard = UIStoryboard(name: "popUpTurun", bundle: nil)
        let nextVC = nextStoryboard.instantiateViewController(identifier: "popUpTurunStoryboard") as popUpTurunViewController
        
        present(nextVC, animated: true, completion: nil)
    }
//    **************
}
