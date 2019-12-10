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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

    }

//    ***** CHANGE PAGE to Alert *****
    @IBAction func btnBatalTurun(_ sender: Any) {
        animateIn()
//        let nextStoryboard = UIStoryboard(name: "CommuteNaikStoryboard", bundle: nil)
//        let nextVC = nextStoryboard.instantiateViewController(identifier: "CommuteNaikStoryboard") as CommuteNaikViewController
//        present(nextVC, animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTurun(_ sender: Any) {
       animateOut()
//        let nextStoryboard = UIStoryboard(name: "CommuteStoryboard", bundle: nil)
//        let nextVC = nextStoryboard.instantiateViewController(identifier: "CommuteStoryboard") as CommuteViewController
//
//        present(nextVC, animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
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
