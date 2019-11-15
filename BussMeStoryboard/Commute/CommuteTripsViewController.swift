//
//  CommuteTripsViewController.swift
//  BussMeStoryboard
//
//  Created by Kevin Susanto on 15/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit

class CommuteTripsViewController: UIViewController {
    
//    **** .xib View Commuter
    @IBOutlet weak var handlerArea: UIView!
    @IBOutlet weak var contentArea: UIView!
    
//    ************

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        
        // Do any additional setup after loading the view.
    }
    
    func style(){
        contentArea.layer.cornerRadius = 1
        
        contentArea.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
