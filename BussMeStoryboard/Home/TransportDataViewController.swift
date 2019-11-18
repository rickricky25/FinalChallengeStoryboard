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
        let query = CKQuery(recordType: "DataScheduleList", predicate: predicate)
        
        publicDatabase.perform(query, inZoneWith: .default) { (result, error) in
            for i in 0...result!.count - 1 {
                let arah = result![i]["arah"]
                let kodeBus = result![i]["kodeBus"] as! String
                let kodeRute = result![i]["kodeRute"]
                let arrNamaStop = result![i]["namaStop"] as? [String]
                let arrWaktu = result![i]["waktu"] as? [String]
                
                for j in 1...11 {
                    if kodeBus == "11" || kodeBus == "12" {
                        var arrWaktuBaru = arrWaktu!
                        for k in 0...7 {
                            let arrHnM = arrWaktuBaru[k].components(separatedBy: ":")
                            let hBaru = Int(arrHnM[0])! + j
                            let menit = Int(arrHnM[1])!
                            if menit < 10 {
                                arrWaktuBaru[k] = "\(hBaru):0\(menit)"
                            } else {
                                arrWaktuBaru[k] = "\(hBaru):\(menit)"
                            }
                        }
                        let newRecord = CKRecord(recordType: "DataScheduleList")
                        newRecord["arah"] = arah
                        newRecord["kodebus"] = kodeBus
                        newRecord["kodeRute"] = kodeRute
                        newRecord["namaStop"] = arrNamaStop
                        newRecord["waktu"] = arrWaktuBaru
                        
                        publicDatabase.save(newRecord) { (record, error) in
                            print(error as Any)
                        }
                    } else if kodeBus == "13" {
                        if j < 10 {
                            var arrWaktuBaru = arrWaktu!
                            for k in 0...7 {
                                let arrHnM = arrWaktuBaru[k].components(separatedBy: ":")
                                let hBaru = Int(arrHnM[0])! + j
                                let menit = Int(arrHnM[1])!
                                if menit < 10 {
                                    arrWaktuBaru[k] = "\(hBaru):0\(menit)"
                                } else {
                                    arrWaktuBaru[k] = "\(hBaru):\(menit)"
                                }
                            }
                            let newRecord = CKRecord(recordType: "DataScheduleList")
                            newRecord["arah"] = arah
                            newRecord["kodebus"] = kodeBus
                            newRecord["kodeRute"] = kodeRute
                            newRecord["namaStop"] = arrNamaStop
                            newRecord["waktu"] = arrWaktuBaru
                            
                            publicDatabase.save(newRecord) { (record, error) in
                                print(error as Any)
                            }
                        }
                    } else if kodeBus == "14" {
                        if j < 9 {
                            var arrWaktuBaru = arrWaktu!
                            for k in 0...7 {
                                let arrHnM = arrWaktuBaru[k].components(separatedBy: ":")
                                let hBaru = Int(arrHnM[0])! + j
                                let menit = Int(arrHnM[1])!
                                if menit < 10 {
                                    arrWaktuBaru[k] = "\(hBaru):0\(menit)"
                                } else {
                                    arrWaktuBaru[k] = "\(hBaru):\(menit)"
                                }
                            }
                            let newRecord = CKRecord(recordType: "DataScheduleList")
                            newRecord["arah"] = arah
                            newRecord["kodeBus"] = kodeBus
                            newRecord["kodeRute"] = kodeRute
                            newRecord["namaStop"] = arrNamaStop
                            newRecord["waktu"] = arrWaktuBaru
                            
                            publicDatabase.save(newRecord) { (record, error) in
                                print(error as Any)
                            }
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
