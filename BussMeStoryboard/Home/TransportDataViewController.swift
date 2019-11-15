//
//  TransportDataViewController.swift
//  BussMeStoryboard
//
//  Created by Ricky Effendi on 15/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit
import CloudKit
import GoogleMaps


class TransportDataViewController: UIViewController {
    
    var arrResult: [CKRecord] = []
    var arrStop: [CKRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let publicDatabase = container.publicCloudDatabase
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "DataGathering", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        
        let queryStop = CKQuery(recordType: "DataStop", predicate: predicate)
        
        publicDatabase.perform(query, inZoneWith: .default) { (result, error) in
            self.arrResult = result!
            publicDatabase.perform(queryStop, inZoneWith: .default) { (result, error) in
                self.arrStop = result!
                var tujuan = ""
                for i in 0...self.arrResult.count - 1 {
                    if i % 2 == 0 {
                        tujuan = self.getNearestStop(currLat: self.arrResult[i]["latitude"]!, currLong: self.arrResult[i]["longitude"]!)
                    } else {
                        let sumber = self.getNearestStop(currLat: self.arrResult[i]["latitude"]!, currLong: self.arrResult[i]["longitude"]!)
                        
                        let newTripRecord = CKRecord(recordType: "DataTrip")
                        
                        // Insert Trip Record
                        newTripRecord["durasi"] = "\(self.countDuration(firstTime: self.arrResult[i]["time"] as! String, secondTime: self.arrResult[i - 1]["time"] as! String))"
                        // Counting which trip it is
                        newTripRecord["idTrip"] = "\((i - 1) / 2 + 1)"
                        if self.arrResult[i]["senderID"] as! String == self.arrResult[i-1]["senderID"] as! String {
                            newTripRecord["idUser"] = self.arrResult[i]["senderID"] as! String
                        } else {
                            newTripRecord["idUser"] = "Unknown"
                        }
                        newTripRecord["kodeKendaraan"] = "BSDLink"
                        newTripRecord["kodeRute"] = "BRE"
                        newTripRecord["sumber"] = sumber
                        newTripRecord["tujuan"] = tujuan
                        newTripRecord["waktu"] = self.arrResult[i]["time"]
                        
//                        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
//                        let publicDatabase = container.publicCloudDatabase
                        
                        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
                        let publicDatabase = container.publicCloudDatabase
                        
                        publicDatabase.save(newTripRecord) { (record, error) in
                            print(error as Any)
                        }
                    }
                }
            }
        }
        
    }
    
    func getNearestStop(currLat: Double, currLong: Double) -> String {
        let currLoc = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
        var nearestStop = arrStop[0]["namaStop"]
        var stopLat = arrStop[0]["latitude"] as! String
        var stopLong = arrStop[0]["longitude"] as! String
        var nearestDist = GMSGeometryDistance(currLoc, CLLocationCoordinate2D(latitude: Double(stopLat)!, longitude: Double(stopLong)!))
        
        for i in 1...arrStop.count - 1 {
            stopLat = arrStop[i]["latitude"] as! String
            stopLong = arrStop[i]["longitude"] as! String
            let stopDist = GMSGeometryDistance(currLoc, CLLocationCoordinate2D(latitude: Double(stopLat)!, longitude: Double(stopLong)!))
            if stopDist < nearestDist {
                nearestDist = stopDist
                nearestStop = arrStop[i]["namaStop"]
            }
        }
        
        return nearestStop as! String
    }
    
    func countDuration(firstTime: String, secondTime: String) -> Int {
        var duration = 0
        
        let arrFirstTime = firstTime.components(separatedBy: ":")
        let arrSecondTime = secondTime.components(separatedBy: ":")
        
        let firstHour = Int(arrFirstTime[0])!
        let secondHour = Int(arrSecondTime[0])!
        let firstMin = Int(arrFirstTime[1])!
        let secondMin = Int(arrSecondTime[1])!
        let firstSec = Int(arrFirstTime[2])!
        let secondSec = Int(arrSecondTime[2])!
        
        if firstHour < secondHour {
            duration = 3600 * (secondHour - firstHour)
        }
        
        if firstMin < secondMin {
            duration = duration + 60 * (secondMin - firstMin)
        } else {
            duration = duration - 60 * (firstMin - secondMin)
        }
        
        if firstSec < secondSec {
            duration = duration + (secondSec - firstSec)
        } else {
            duration = duration - (firstSec - secondSec)
        }
        
        return duration
    }
}
