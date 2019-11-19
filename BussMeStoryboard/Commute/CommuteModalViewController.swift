//
//  CommuteModalViewController.swift
//  BussMeStoryboard
//
//  Created by Kevin Susanto on 13/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit

var arah: String?
var rute: String?

class CommuteModalViewController: UIViewController {

    @IBOutlet var handleArea: UIView!
    @IBOutlet var contentArea: UIView!
    @IBOutlet weak var BreezeIceView: UIView!
    @IBOutlet weak var IceBreezeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapBreeze = UITapGestureRecognizer(target: self, action: #selector(self.handleTapBreeze(_:)))
        let tapIce = UITapGestureRecognizer(target: self, action: #selector(handleTapIce(_:)))
        
        BreezeIceView.layer.cornerRadius = 10
        IceBreezeView.layer.cornerRadius = 10
        
        contentArea.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentArea.layer.shadowOpacity = 0.1
        contentArea.layer.shadowRadius = 15
        
        
        BreezeIceView.addGestureRecognizer(tapBreeze)
        IceBreezeView.addGestureRecognizer(tapIce)
        
        BreezeIceView.isUserInteractionEnabled = true
        IceBreezeView.isUserInteractionEnabled = true
    }
    
    @objc func handleTapBreeze(_ sender: UITapGestureRecognizer) {
        let nextStoryboard = UIStoryboard(name: "NavDetailStoryboard", bundle: nil)
        let nextVC = nextStoryboard.instantiateViewController(identifier: "NavDetailStoryboard") as NavDetailViewController
        arah = "pergi"
        rute = "BRE"
        present(nextVC, animated: true, completion: nil)
    }
    
    @objc func handleTapIce(_ sender: UITapGestureRecognizer) {
        let nextStoryboard = UIStoryboard(name: "NavDetailStoryboard", bundle: nil)
        let nextVC = nextStoryboard.instantiateViewController(identifier: "NavDetailStoryboard") as NavDetailViewController
        arah = "pulang"
        rute = "BRE"
        present(nextVC, animated: true, completion: nil)
    }
}
