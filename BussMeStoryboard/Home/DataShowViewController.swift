//
//  DataShowViewController.swift
//  BussMeStoryboard
//
//  Created by Ricky Effendi on 05/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit
import CloudKit

class DataShowViewController: UIViewController {
    @IBOutlet weak var DataShowTableView: UITableView!
    
    var hasilQuery: [CKRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataShowTableView.delegate = self
        DataShowTableView.dataSource = self
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "DataGathering", predicate: predicate)
        
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let publicDatabase = container.publicCloudDatabase
        
        publicDatabase.perform(query, inZoneWith: nil) { (hasil, error) in
            print(hasil)
            self.hasilQuery = hasil!
            
            DispatchQueue.main.async {
                self.DataShowTableView.reloadData()
            }
        }

        // Do any additional setup after loading the view.
    }

}

extension DataShowViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hasilQuery.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DataShowTableView.dequeueReusableCell(withIdentifier: "DataShowCell", for: indexPath) as! DataShowTableViewCell
        cell.lblSender.text = hasilQuery[indexPath.row]["senderID"] as! String
        cell.lblWaktu.text = hasilQuery[indexPath.row]["time"] as! String
        cell.lblStatus.text = hasilQuery[indexPath.row]["status"] as! String
        
        let currLocation = CLLocation(latitude: hasilQuery[indexPath.row]["latitude"] as! CLLocationDegrees, longitude: <#T##CLLocationDegrees#>)
        
        return cell
    }
    
    
}
