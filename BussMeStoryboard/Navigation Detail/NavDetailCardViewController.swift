//
//  NavDetailCardViewController.swift
//  BussMeStoryboard
//
//  Created by Kevin Susanto on 18/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit
import CloudKit

class NavDetailCardViewController: UIViewController {
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var contentArea: UIView!
    @IBOutlet weak var kodeRuteView: UIView!
    @IBOutlet var listRuteView: UIView!
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
    
    var routePergi: [String] = []
    var routePulang: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var resultRoute: [CKRecord] = []

        kodeRuteView.layer.cornerRadius = 15
        listRuteView.layer.cornerRadius = 15
        
        contentArea.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentArea.layer.shadowOpacity = 0.1
        contentArea.layer.shadowRadius = 15
        contentArea.layer.cornerRadius = 25
        
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let predicate = NSPredicate(format: "kodeRute == %@", "BRE")
        let query = CKQuery(recordType: "DataRoute", predicate: predicate)
        let publicDatabase = container.publicCloudDatabase
        
        publicDatabase.perform(query, inZoneWith: nil) { (result, error) in
            resultRoute = result!
            
            if resultRoute[0]["arah"] == "pergi" {
                self.routePergi = resultRoute[0]["namaStop"]!
                self.routePulang = resultRoute[1]["namaStop"]!
            } else {
                self.routePergi = resultRoute[1]["namaStop"]!
                self.routePulang = resultRoute[0]["namaStop"]!
            }
            DispatchQueue.main.async {
                if arah == "pergi" {
                    self.arahSegmentedControl.selectedSegmentIndex = 0
                    self.kodeRute.text = "Breeze - ICE"
                    self.lblStop1.text = self.routePergi[0]
                    self.lblStop2.text = self.routePergi[1]
                    self.lblStop3.text = self.routePergi[2]
                    self.lblStop4.text = self.routePergi[3]
                    self.lblStop5.text = self.routePergi[4]
                    self.lblStop6.text = self.routePergi[5]
                    self.lblStop7.text = self.routePergi[6]
                    self.lblStop8.text = self.routePergi[7]
                } else if arah == "pulang" {
                    self.arahSegmentedControl.selectedSegmentIndex = 1
                    self.kodeRute.text = "ICE - Breeze"
                    self.lblStop1.text = self.routePulang[0]
                    self.lblStop2.text = self.routePulang[1]
                    self.lblStop3.text = self.routePulang[2]
                    self.lblStop4.text = self.routePulang[3]
                    self.lblStop5.text = self.routePulang[4]
                    self.lblStop6.text = self.routePulang[5]
                    self.lblStop7.text = self.routePulang[6]
                    self.lblStop8.text = self.routePulang[7]
                }
            }
        }
    }
    
    @IBAction func arahSegmentedControlAction(_ sender: Any) {
        if arahSegmentedControl.selectedSegmentIndex == 0 {
            print("pergi")
            kodeRute.text = "Breeze - ICE"
            lblStop1.text = routePergi[0]
            lblStop2.text = routePergi[1]
            lblStop3.text = routePergi[2]
            lblStop4.text = routePergi[3]
            lblStop5.text = routePergi[4]
            lblStop6.text = routePergi[5]
            lblStop7.text = routePergi[6]
            lblStop8.text = routePergi[7]
        } else {
            print("pulang")
            kodeRute.text = "ICE - Breeze"
            lblStop1.text = routePulang[0]
            lblStop2.text = routePulang[1]
            lblStop3.text = routePulang[2]
            lblStop4.text = routePulang[3]
            lblStop5.text = routePulang[4]
            lblStop6.text = routePulang[5]
            lblStop7.text = routePulang[6]
            lblStop8.text = routePulang[7]
        }
    }
    
}
