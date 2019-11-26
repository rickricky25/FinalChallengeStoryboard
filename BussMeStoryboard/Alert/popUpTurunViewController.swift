//
//  popUpTurunViewController.swift
//  BussMeStoryboard
//
//  Created by Kevin Susanto on 26/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit

class popUpTurunViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

//    ***** CHANGE PAGE to Alert *****
    @IBAction func btnBatalTurun(_ sender: Any) {
        let nextStoryboard = UIStoryboard(name: "imIn", bundle: nil)
        let nextVC = nextStoryboard.instantiateViewController(identifier: "imIn") as CommuteNaikViewController
        
        present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func btnTurun(_ sender: Any) {
        let nextStoryboard = UIStoryboard(name: "commuteStoryboard", bundle: nil)
        let nextVC = nextStoryboard.instantiateViewController(identifier: "commuteStoryboard") as CommuteViewController
        
        present(nextVC, animated: true, completion: nil)
    }
//    *******************
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
