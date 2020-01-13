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
    var nearPulang: String = ""
    var nearPergi: String = ""
    
    var selPergi: Int!
    var selPulang: Int!
    var waktuPergi: [String] = []
    var waktuPulang: [String] = []
    
    var delegate: XibDelegate?
    
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
        
        // GESTURE
        let edgeContent = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        edgeContent.edges = .left
        edgeContent.delegate = self
        
        contentArea.addGestureRecognizer(edgeContent)
        contentArea.isUserInteractionEnabled = true
    }
    
    func getCurrTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        
        return "\(components.hour!):\(components.minute!)"
    }
    
//    func getNearestStop(currLat: CLLocationDegrees, currLong: CLLocationDegrees, completion: @escaping (_ stop: String) -> ()) {
//        // CloudKit
//
//        let currLocation = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
//        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
//        let predicate = NSPredicate(value: true)
//        let query = CKQuery(recordType: "DataRoute", predicate: predicate)
//        let publicDatabase = container.publicCloudDatabase
//        var nearestStop = ""
//        var nearestDistance: Double = 0
//
//        publicDatabase.perform(query, inZoneWith: nil) { (routes, error) in
//            for route in routes! {
//                let arrStop = route["namaStop"] as! [String]
//                let arrLat = route["latStop"] as! [CLLocationDegrees]
//                let arrLong = route["longStop"] as! [CLLocationDegrees]
//                var stopLoc = CLLocationCoordinate2D(latitude: arrLat[0], longitude: arrLong[0])
//
//                nearestStop = arrStop[0]
//                nearestDistance = self.countDistance(firstLoc: currLocation, secondLoc: stopLoc)
//
//                for i in 1...arrStop.count - 1 {
//                    stopLoc = CLLocationCoordinate2D(latitude: arrLat[i], longitude: arrLong[i])
//                    let currDist = self.countDistance(firstLoc: currLocation, secondLoc: stopLoc)
//                    if currDist < nearestDistance {
//                        nearestDistance = currDist
//                        nearestStop = arrStop[i]
//                    }
//                }
//
//            }
//            completion(nearestStop)
//        }
//    }
    
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
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        delegate?.navBackPressed()
    }
    
    @IBAction func btnNaikPressed(_ sender: Any) {
        // CloudKit
        let (currLat, currLong) = getCurrentLatLong()
        
        if arah == "pergi" {
            API().getStopsByRoute(bus_id: 1, direction: "depart") { (resDepart) in
                for i in 0...(resDepart?.stops!.count)! - 1 {
                    self.resultDepartStops = resDepart
                    
                    let (currLat, currLong) = self.getCurrentLatLong()
                    let currLoc = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
                    
                    let latDepart = resDepart?.stops![i].latitude
                    let longDepart = resDepart?.stops![i].longitude
                    let departLoc = CLLocationCoordinate2D(latitude: latDepart!, longitude: longDepart!)
                    let departDist = GMSGeometryDistance(departLoc, currLoc)
                    let stopName = resDepart?.stops![i].stop_name
                    
                    if i == 0 {
                        self.nearestDistDepart = departDist
                        self.nearestStopDepartObj = resDepart?.stops![i]
                        self.nearestDepartName = stopName
                    } else {
                        if departDist < self.nearestDistDepart {
                            self.nearestDistDepart = departDist
                            self.nearestStopDepartObj = resDepart?.stops![i]
                            self.nearestDepartName = stopName
                        }
                    }
                }
            }
            
            API().addCommute(user_id: 28, stop_id: 1, stop_name: self.nearestDepartName!, direction: "depart", bus_code: "BRE", longitude: currLong, latitude: currLat, status_check: "go")
        } else {
            API().getStopsByRoute(bus_id: 1, direction: "return") { (resReturn) in
                for i in 0...(resReturn?.stops!.count)! - 1 {
                    self.resultReturnStops = resReturn
                    
                    let (currLat, currLong) = self.getCurrentLatLong()
                    let currLoc = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
                    
                    let latReturn = resReturn?.stops![i].latitude
                    let longReturn = resReturn?.stops![i].longitude
                    let returnLoc = CLLocationCoordinate2D(latitude: latReturn!, longitude: longReturn!)
                    let returnDist = GMSGeometryDistance(returnLoc, currLoc)
                    let stopName = resReturn?.stops![i].stop_name
                    
                    if i == 0 {
                        self.nearestDistReturn = returnDist
                        self.nearestStopReturnObj = resReturn?.stops![i]
                        self.nearestReturnName = stopName
                    } else {
                        if returnDist < self.nearestDistDepart {
                            self.nearestDistReturn = returnDist
                            self.nearestStopReturnObj = resReturn?.stops![i]
                            self.nearestReturnName = stopName
                        }
                    }
                }
            }
            
            API().addCommute(user_id: 28, stop_id: 1, stop_name: self.nearestReturnName!, direction: "return", bus_code: "BRE", longitude: currLong, latitude: currLat, status_check: "go")
        }
    }
    
    var resultDepartStops: API.ApiResultStop?
    var resultReturnStops: API.ApiResultStop?
    
    var nearestDistDepart: Double = 0
    var nearestDistReturn: Double = 0
    
    var nearestStopDepartObj: API.Stops?
    var nearestStopReturnObj: API.Stops?
    
    var nearestDepartName: String?
    var nearestReturnName: String?
    
    @IBAction func arahSegmentedControlAction(_ sender: UISegmentedControl) {
        if arahSegmentedControl.selectedSegmentIndex == 0 {
            delegate?.navSegmentedSelected(index: 0)
        } else if arahSegmentedControl.selectedSegmentIndex == 1 {
            delegate?.navSegmentedSelected(index: 1)
        }
    }
    
    
    //    ***** CHANGE PAGE to Alert *****
    @IBAction func btnIngatkan(_ sender: Any) {
        let nextStoryboard = UIStoryboard(name: "popUpReminder", bundle: nil)
        let nextVC = nextStoryboard.instantiateViewController(identifier: "popUpReminder") as popUpReminderViewController
        
        present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func btnNaikBus(_ sender: Any) {
        if arahSegmentedControl.selectedSegmentIndex == 0 {
            arah = "depart"
        } else {
            arah = "return"
        }
        delegate?.naikBtnPressed(rute: "BRE", arah: arah)
    }
    //    *******************
}
