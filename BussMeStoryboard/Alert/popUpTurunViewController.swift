//
//  popUpTurunViewController.swift
//  BussMeStoryboard
//
//  Created by Kevin Susanto on 26/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit

class popUpTurunViewController: UIViewController {

    @IBOutlet var popupBox: UIView!
    @IBOutlet var blurEffect: UIVisualEffectView!
    
    var delegate: XibDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateIn()
    }

//    ***** CHANGE PAGE to Alert *****
    @IBAction func btnBatalTurun(_ sender: Any) {
        animateOut()
//        navigationController?.popViewController(animated: true)
        delegate?.turunChoicePressed(index: 0)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnTurun(_ sender: Any) {
        animateOut()
//        navigationController?.popViewController(animated: true)
        delegate?.turunChoicePressed(index: 1)
        self.dismiss(animated: true, completion: nil)
    }
    
//    ******** ALERT ANIMATION ***********
    func animateIn() {
        self.view.addSubview(popupBox)
        
        popupBox.center = self.view.center
        popupBox.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popupBox.alpha = 0
        
        UIView.animate(withDuration: 1, animations: {
            self.blurEffect.isHidden = false
            self.popupBox.alpha = 1
            self.popupBox.transform = CGAffineTransform.identity
        })
    }
    
    func animateOut() {
        self.view.addSubview(popupBox)
        UIView.animate(withDuration: 0.5, animations: {
            self.popupBox.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            self.popupBox.alpha = 0
            self.blurEffect.alpha = 0
        })
    }
    
  
    
}
