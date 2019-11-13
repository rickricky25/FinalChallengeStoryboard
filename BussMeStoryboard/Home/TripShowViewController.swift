//
//  TripShowViewController.swift
//  BussMeStoryboard
//
//  Created by Ricky Effendi on 11/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit
import CloudKit
import GoogleMaps

class TripShowViewController: UIViewController {

    @IBOutlet weak var TripShowTable: UITableView!
    
    var hasilQuery: [CKRecord] = []
    var hasilStops: [CKRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TripShowTable.delegate = self
        TripShowTable.dataSource = self
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "DataGathering", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        
        let queryStop = CKQuery(recordType: "DataStop", predicate: predicate)
        
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let publicDatabase = container.publicCloudDatabase
        
        publicDatabase.perform(queryStop, inZoneWith: nil) { (hasil, error) in
            self.hasilStops = hasil!
        }
        
        publicDatabase.perform(query, inZoneWith: nil) { (hasil, error) in
            self.hasilQuery = hasil!
            
            DispatchQueue.main.async {
                self.TripShowTable.reloadData()
            }
        }
        
    }
}

extension TripShowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hasilQuery.count/2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TripShowTable.dequeueReusableCell(withIdentifier: "TripShowCell", for: indexPath) as! TripShowTableViewCell
        var boolAdaSumber = false
        var boolAdaTujuan = false
        
        var durasi = 0
        let waktuAwal = hasilQuery[indexPath.row * 2 + 1]["time"] as! String
        let waktuAkhir = hasilQuery[indexPath.row * 2]["time"] as! String
        
        let arrWaktuAwal = waktuAwal.components(separatedBy: ":")
        let arrWaktuAkhir = waktuAkhir.components(separatedBy: ":")
        
        let jamAwal = Int(arrWaktuAwal[0])!
        let jamAkhir = Int(arrWaktuAkhir[0])!
        let menitAwal = Int(arrWaktuAwal[1])!
        let menitAkhir =  Int(arrWaktuAkhir[1])!
        let detikAwal = Int(arrWaktuAwal[2])!
        let detikAkhir = Int(arrWaktuAkhir[2])!
        
        if jamAwal < jamAkhir {
            durasi = 3600 * (jamAkhir - jamAwal)
        }
        
        if menitAwal < menitAkhir {
            durasi = durasi + 60 * (menitAkhir - menitAwal)
        } else {
            durasi = durasi - 60 * (menitAwal - menitAkhir)
        }
        
        if detikAwal < detikAkhir {
            durasi = durasi + (detikAkhir - detikAwal)
        } else {
            durasi = durasi - (detikAwal - detikAkhir)
        }
        
        let coorSumber = CLLocationCoordinate2D(latitude: hasilQuery[indexPath.row * 2 + 1]["latitude"] as! CLLocationDegrees, longitude: hasilQuery[indexPath.row * 2 + 1]["longitude"] as! CLLocationDegrees)
        let coorTujuan = CLLocationCoordinate2D(latitude: hasilQuery[indexPath.row * 2]["latitude"] as! CLLocationDegrees, longitude: hasilQuery[indexPath.row + 2]["longitude"] as! CLLocationDegrees)
        
        for i in 0...hasilStops.count - 1 {
            let stopLat = hasilStops[i]["latitude"] as! String
            let stopLong = hasilStops[i]["longitude"] as! String
            let stopCoor = CLLocationCoordinate2D(latitude: Double(stopLat) as! CLLocationDegrees, longitude: Double(stopLong) as! CLLocationDegrees)
            let distanceSumber = GMSGeometryDistance(coorSumber, stopCoor)
            let distanceTujuan = GMSGeometryDistance(coorTujuan, stopCoor)
                    
            if distanceSumber < 200 {
                cell.lblSumber.text = hasilStops[i]["namaStop"]
                boolAdaSumber = true
                break
            }
            
            if distanceTujuan < 200 {
                cell.lblTujuan.text = hasilStops[i]["namaStop"]
                boolAdaTujuan = true
            }
        }
                
        if boolAdaSumber == false {
            cell.lblSumber.text = "Unknown"
        }
        
        if boolAdaTujuan == false {
            cell.lblTujuan.text = "Unknown"
        }
        
        cell.lblDurasi.text = "\(durasi) detik"
        
        cell.lblWaktu.text = hasilQuery[indexPath.row * 2 + 1]["time"]
        
        return cell
    }
    
    
}
