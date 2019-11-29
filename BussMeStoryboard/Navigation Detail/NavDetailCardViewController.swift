//
//  NavDetailCardViewController.swift
//  BussMeStoryboard
//
//  Created by Kevin Susanto on 18/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit
import CloudKit
import GoogleMaps

class NavDetailCardViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var lblStop: UILabel!
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var contentArea: UIView!
    @IBOutlet weak var kodeRuteView: UIView!
    @IBOutlet var listRuteView: UIView!
    @IBOutlet weak var arahSegmentedControl: UISegmentedControl!
    @IBOutlet weak var kodeRute: UILabel!
    @IBOutlet weak var btnNaik: UIButton!
    
    @IBOutlet weak var lblStop1: UILabel!
    @IBOutlet weak var lblStop2: UILabel!
    @IBOutlet weak var lblStop3: UILabel!
    @IBOutlet weak var lblStop4: UILabel!
    @IBOutlet weak var lblStop5: UILabel!
    @IBOutlet weak var lblStop6: UILabel!
    @IBOutlet weak var lblStop7: UILabel!
    @IBOutlet weak var lblStop8: UILabel!
    
    @IBOutlet weak var lblTime1: UILabel!
    @IBOutlet weak var lblTime2: UILabel!
    @IBOutlet weak var lblTime3: UILabel!
    @IBOutlet weak var lblTime4: UILabel!
    @IBOutlet weak var lblTime5: UILabel!
    @IBOutlet weak var lblTime6: UILabel!
    @IBOutlet weak var lblTime7: UILabel!
    @IBOutlet weak var lblTime8: UILabel!
    
    @IBOutlet weak var lblShortestTime1: UILabel!
    @IBOutlet weak var lblShortestTime2: UILabel!
    @IBOutlet weak var lblShortestTime3: UILabel!
    
    var routePergi: [String] = []
    var routePulang: [String] = []
    var locManager = CLLocationManager()
    
    var selPergi: Int!
    var selPulang: Int!
    var waktuPergi: [String] = []
    var waktuPulang: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var resultRoute: [CKRecord] = []

        kodeRuteView.layer.cornerRadius = 15
        listRuteView.layer.cornerRadius = 15
        
        contentArea.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentArea.layer.shadowOpacity = 0.1
        contentArea.layer.shadowRadius = 15
        contentArea.layer.cornerRadius = 25
        
        lblStop.text = stop
        
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(format: "kodeRute == %@", rute!)
        let query = CKQuery(recordType: "DataRoute", predicate: predicate)
        
        getShortestTime(rute: rute!) { (selisihPergi, selisihPulang, timesPergi, timesPulang) in
            self.selPergi = selisihPergi
            self.selPulang = selisihPulang
            self.waktuPergi = timesPergi
            self.waktuPulang = timesPulang
            
            DispatchQueue.main.async {
                if self.arahSegmentedControl.selectedSegmentIndex == 0 {
                    self.lblShortestTime1.text = "\(self.selPergi!)"
                    self.lblShortestTime2.text = "\(self.selPergi! + 15)"
                    self.lblShortestTime3.text = "\(self.selPergi! + 30)"
                    
                    self.lblTime1.text = self.waktuPergi[0]
                    self.lblTime2.text = self.waktuPergi[1]
                    self.lblTime3.text = self.waktuPergi[2]
                    self.lblTime4.text = self.waktuPergi[3]
                    self.lblTime5.text = self.waktuPergi[4]
                    self.lblTime6.text = self.waktuPergi[5]
                    self.lblTime7.text = self.waktuPergi[6]
                    self.lblTime8.text = self.waktuPergi[7]
                } else if self.arahSegmentedControl.selectedSegmentIndex == 1 {
                    self.lblShortestTime1.text = "\(self.selPulang!)"
                    self.lblShortestTime2.text = "\(self.selPulang! + 15)"
                    self.lblShortestTime3.text = "\(self.selPulang! + 30)"
                    
                    self.lblTime1.text = self.waktuPulang[0]
                    self.lblTime2.text = self.waktuPulang[1]
                    self.lblTime3.text = self.waktuPulang[2]
                    self.lblTime4.text = self.waktuPulang[3]
                    self.lblTime5.text = self.waktuPulang[4]
                    self.lblTime6.text = self.waktuPulang[5]
                    self.lblTime7.text = self.waktuPulang[6]
                    self.lblTime8.text = self.waktuPulang[7]
                }
            }

        }
        
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
        
        // GESTURE
        let edgeContent = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        edgeContent.edges = .left
        edgeContent.delegate = self
        
        contentArea.addGestureRecognizer(edgeContent)
        contentArea.isUserInteractionEnabled = true
    }
    
    func getShortestTime(rute: String, completion: @escaping (_ selisihPergi: Int, _ selisihPulang: Int, _ timesPergi: [String], _ timesPulang: [String]) -> ()) {
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let publicDatabase = container.publicCloudDatabase
        let predicateStop = NSPredicate(format: "kodeRute == %@", rute)
        let queryStop = CKQuery(recordType: "DataScheduleList", predicate: predicateStop)
        
        var selPergi: Int = 0
        var selPulang: Int = 0
        var waktuPergi: [String] = []
        var waktuPulang: [String] = []
        
        publicDatabase.perform(queryStop, inZoneWith: nil) { (resultStops, error) in
            if error == nil {
                let currTime = self.getCurrTime()
                let arrCurrTime = currTime.components(separatedBy: ":")
                let currHour = Int(arrCurrTime[0])
                let currMinute = Int(arrCurrTime[1])
                
//                print(currTime)
                
                var arrStopPergi: [CKRecord] = []
                var arrStopPulang: [CKRecord] = []
                
                for resultStop in resultStops! {
                    if resultStop["arah"] == "pergi" {
                        arrStopPergi.append(resultStop)
                    } else if resultStop["arah"] == "pulang" {
                        arrStopPulang.append(resultStop)
                    }
                }
                
                var minSelisih = 1000000000
                var nearestIndex = 0
                var index = 0
                for stopPergi in arrStopPergi {
                    let arrStop = stopPergi["namaStop"] as! [String]
                    let arrWaktu = stopPergi["waktu"] as! [String]
                    
                    for i in 0...arrStop.count - 1 {
                        if arrStop[i] == stop {
                            let stopTime = arrWaktu[i]
                            let arrStopTime = stopTime.components(separatedBy: ":")
                            let stopHour = Int(arrStopTime[0])
                            let stopMinute = Int(arrStopTime[1])
                            
                            if currHour! == stopHour!{
                                if stopMinute! >= currMinute! {
                                    let selisih = stopMinute! - currMinute!
                                    if minSelisih > selisih {
                                        minSelisih = selisih
                                        nearestIndex = index
//                                        print("\(nearestIndex) selisih \(minSelisih)")
                                    }
                                }
                            } else if currHour! == stopHour! - 1 {
                                let selisih = 60 - currMinute! + stopMinute!
                                if minSelisih > selisih {
                                    minSelisih = selisih
                                    nearestIndex = index
//                                    print("\(nearestIndex) selisih \(minSelisih)")
                                }
                            }
                        }
                    }
                    index = index + 1
                }
                selPergi = minSelisih
//                print(selPergi)
                waktuPergi = arrStopPergi[nearestIndex]["waktu"] as! [String]
                
                nearestIndex = 0
                minSelisih = 1000000000
                index = 0
                
                for stopPulang in arrStopPulang {
                    let arrStop = stopPulang["namaStop"] as! [String]
                    let arrWaktu = stopPulang["waktu"] as! [String]
                    
                    for i in 0...arrStop.count - 1 {
                        if arrStop[i] == stop {
                            let stopTime = arrWaktu[i]
                            let arrStopTime = stopTime.components(separatedBy: ":")
                            let stopHour = Int(arrStopTime[0])
                            let stopMinute = Int(arrStopTime[1])
                            
                            if currHour! == stopHour!{
                                if stopMinute! > currMinute! {
                                    let selisih = stopMinute! - currMinute!
                                    if minSelisih > selisih {
                                        minSelisih = selisih
                                        nearestIndex = index
                                    }
                                }
                            } else if currHour! == stopHour! - 1 {
                                let selisih = 60 - currMinute! + stopMinute!
                                if minSelisih > selisih {
                                    minSelisih = selisih
                                    nearestIndex = index
                                }
                            }
                        }
                    }
                    index = index + 1
                }
                selPulang = minSelisih
//                print(selPulang)
                waktuPulang = arrStopPulang[nearestIndex]["waktu"] as! [String]
                
                completion(selPergi, selPulang, waktuPergi, waktuPulang)
            } else {
                print(error as Any)
            }
        }
    }
    
    func getCurrTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        
        return "\(components.hour!):\(components.minute!)"
    }
    
    func getNearestStop(currLat: CLLocationDegrees, currLong: CLLocationDegrees, completion: @escaping (_ stop: String) -> ()) {
        let currLocation = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "DataRoute", predicate: predicate)
        let publicDatabase = container.publicCloudDatabase
        var nearestStop = ""
        var nearestDistance: Double = 0
        
        publicDatabase.perform(query, inZoneWith: nil) { (routes, error) in
            for route in routes! {
                let arrStop = route["namaStop"] as! [String]
                let arrLat = route["latStop"] as! [CLLocationDegrees]
                let arrLong = route["longStop"] as! [CLLocationDegrees]
                var stopLoc = CLLocationCoordinate2D(latitude: arrLat[0], longitude: arrLong[0])
                
                nearestStop = arrStop[0]
                nearestDistance = self.countDistance(firstLoc: currLocation, secondLoc: stopLoc)
                
                for i in 1...arrStop.count - 1 {
                    stopLoc = CLLocationCoordinate2D(latitude: arrLat[i], longitude: arrLong[i])
                    let currDist = self.countDistance(firstLoc: currLocation, secondLoc: stopLoc)
                    if currDist < nearestDistance {
                        nearestDistance = currDist
                        nearestStop = arrStop[i]
                    }
                }
                
            }
            completion(nearestStop)
        }
    }
    
    func countDistance(firstLoc: CLLocationCoordinate2D, secondLoc: CLLocationCoordinate2D) -> Double {
        return GMSGeometryDistance(firstLoc, secondLoc)
    }
    
    func getCurrentLatLong() -> (Double, Double) {
        var currentLocation: CLLocation!
            
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLocation = locManager.location
        }
            
        let currLong = currentLocation.coordinate.longitude
        let currLat = currentLocation.coordinate.latitude
            
        return (currLat, currLong)
    }
    
    @objc func handleEdgePan(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.edges == .left {
            let prevStoryboard = UIStoryboard(name: "CommuteStoryboard", bundle: nil)
            let prevVC = prevStoryboard.instantiateViewController(identifier: "CommuteStoryboard") as CommuteViewController
            present(prevVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnNaikPressed(_ sender: Any) {
        let newRecord = CKRecord(recordType: "DataCheck")
        let (currLat, currLong) = getCurrentLatLong()

        getNearestStop(currLat: currLat, currLong: currLong, completion: { (nearestLoc) in
            newRecord["arah"] = arah!
            newRecord["idUser"] = UIDevice.current.identifierForVendor?.uuidString
            newRecord["kodeKendaraan"] = kendaraan!
            newRecord["kodeRute"] = rute!
            newRecord["lokasi"] = nearestLoc
            newRecord["waktu"] = self.getCurrTime()
            
            let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
            let publicDatabase = container.publicCloudDatabase
            
            publicDatabase.save(newRecord) { (record, error) in
                print(error as Any)
            }
        })
    }
    
    @IBAction func arahSegmentedControlAction(_ sender: UISegmentedControl) {
        if arahSegmentedControl.selectedSegmentIndex == 0 {
            lblShortestTime1.text = "\(selPergi!)"
            lblShortestTime2.text = "\(selPergi! + 15)"
            lblShortestTime3.text = "\(selPergi! + 30)"
            
            lblStop1.text = waktuPergi[0]
            lblStop2.text = waktuPergi[1]
            lblStop3.text = waktuPergi[2]
            lblStop4.text = waktuPergi[3]
            lblStop5.text = waktuPergi[4]
            lblStop6.text = waktuPergi[5]
            lblStop7.text = waktuPergi[6]
            lblStop8.text = waktuPergi[7]
        } else if arahSegmentedControl.selectedSegmentIndex == 1 {
            lblShortestTime1.text = "\(selPulang!)"
            lblShortestTime2.text = "\(selPulang! + 15)"
            lblShortestTime3.text = "\(selPulang! + 30)"
            
            lblStop1.text = waktuPulang[0]
            lblStop2.text = waktuPulang[1]
            lblStop3.text = waktuPulang[2]
            lblStop4.text = waktuPulang[3]
            lblStop5.text = waktuPulang[4]
            lblStop6.text = waktuPulang[5]
            lblStop7.text = waktuPulang[6]
            lblStop8.text = waktuPulang[7]
        }
        
        if arahSegmentedControl.selectedSegmentIndex == 0 {
//            print("pergi")
            arah = "pergi"
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
//            print("pulang")
            arah = "pulang"
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
