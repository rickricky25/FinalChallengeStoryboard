//
//  DataShowViewController.swift
//  BussMeStoryboard
//
//  Created by Ricky Effendi on 05/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit
import CloudKit
import GoogleMaps

class DataShowViewController: UIViewController {
    @IBOutlet weak var DataShowTableView: UITableView!
    
    var hasilQuery: [CKRecord] = []
    var hasilStops: [CKRecord] = []
    var maxDist = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataShowTableView.delegate = self
        DataShowTableView.dataSource = self
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "DataGathering", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        
        let queryStops = CKQuery(recordType: "DataStop", predicate: predicate)
        
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let publicDatabase = container.publicCloudDatabase
        
        publicDatabase.perform(queryStops, inZoneWith: nil) { (hasil, error) in
//            print(hasil)
            self.hasilStops = hasil!
        }
        
        publicDatabase.perform(query, inZoneWith: nil) { (hasil, error) in
//            print(hasil)
            self.hasilQuery = hasil!
            print(self.hasilQuery.count)
            
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
        let senderID = hasilQuery[indexPath.row]["senderID"] as! String
        var boolAda = false
        
        if senderID == "DBEB04B1-D1D4-4722-9D22-B5F5B0492321" {
            cell.lblSender.text = "Khairani Ummah"
        } else if senderID == "7DB38D52-9FCC-4355-9368-CF727BB0CAB8" {
            cell.lblSender.text = "Regnauldy Tanri"
        } else {
            cell.lblSender.text = senderID
        }
        
        cell.lblWaktu.text = hasilQuery[indexPath.row]["time"] as! String
        cell.lblStatus.text = hasilQuery[indexPath.row]["status"] as! String
        
//        let currLocation = CLLocation(latitude: hasilQuery[indexPath.row]["latitude"] as! CLLocationDegrees, longitude: hasilQuery[indexPath.row]["longitude"] as! CLLocationDegrees)
        
//        let breezeCoor = CLLocation(latitude: -6.301424114612514, longitude: 106.6530194285071)
        let currLocation = CLLocationCoordinate2D(latitude: hasilQuery[indexPath.row]["latitude"] as! CLLocationDegrees, longitude: hasilQuery[indexPath.row]["longitude"] as! CLLocationDegrees)
        
//        print(hasilStops.first!["latitude"])
        
        for i in 0...hasilStops.count - 1 {
            let stopLat = hasilStops[i]["latitude"] as! String
            let stopLong = hasilStops[i]["longitude"] as! String
            let stopCoor = CLLocationCoordinate2D(latitude: Double(stopLat) as! CLLocationDegrees, longitude: Double(stopLong) as! CLLocationDegrees)
            let distance = GMSGeometryDistance(currLocation, stopCoor)
            
            if distance < 200 {
                if Int(distance) > maxDist {
                    maxDist = Int(distance)
//                    print(maxDist)
                }
                
                cell.lblLokasi.text = hasilStops[i]["namaStop"]
                boolAda = true
                break
            }
        }
        
        if boolAda == false {
            cell.lblLokasi.text = "Unknown"
            print("Location: \(currLocation)")
        }
        
//        let breezeCoor = CLLocationCoordinate2D(latitude: -6.301424114612514, longitude: 106.6530194285071)
//
//        let aeonCoor = CLLocationCoordinate2D(latitude: -6.303966291002686, longitude: 106.64359257078173)
//
//        let cbdCoor = CLLocationCoordinate2D(latitude:-6.302283800009765, longitude: 106.64198972523076)
//
//        let navaCoor = CLLocationCoordinate2D(latitude: -6.299803330669474, longitude: 106.64979928990496)
//
//        let iceCoor = CLLocationCoordinate2D(latitude: -6.299942608670262, longitude: 106.63597178635129)
//
//        let distanceb = GMSGeometryDistance(currLocation, breezeCoor)
//        if distanceb < 50 {
//            cell.lblLokasi.text = "The Breeze"
//        } else {
//            let distancea = GMSGeometryDistance(currLocation, aeonCoor)
//            if distancea < 50 {
//                cell.lblLokasi.text = "Aeon Mall"
//            } else {
//                let distancec = GMSGeometryDistance(currLocation, cbdCoor)
//                if distancec < 50 {
//                    cell.lblLokasi.text = "CBD"
//                } else {
//                    let distancen = GMSGeometryDistance(currLocation, navaCoor)
//                    if distancen < 50 {
//                        cell.lblLokasi.text = "Nava Park"
//                    } else {
//                        let distancei = GMSGeometryDistance(currLocation, iceCoor)
//                        if distancei < 50 {
//                            cell.lblLokasi.text = "ICE"
//                        } else {
//                            cell.lblLokasi.text = "Unknown"
//                        }
//                    }
//                }
//            }
//        }
        
        return cell
    }
    
    
}
