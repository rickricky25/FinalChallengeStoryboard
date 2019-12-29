//
//  CommuteModalViewController.swift
//  BussMeStoryboard
//
//  Created by Kevin Susanto on 13/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import CloudKit
import SystemConfiguration


var arah: String = "pergi"
var rute: String = "BRE"
var stop: String?
var kendaraan: String = "BSDLink"

class CommuteModalViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var handleArea: UIView!
    @IBOutlet var contentArea: UIView!
    @IBOutlet weak var BreezeIceView: UIView!
    @IBOutlet weak var IceBreezeView: UIView!
    @IBOutlet weak var lblNearestStop: UILabel!
    
    var locManager = CLLocationManager()
    var xibDelegate: XibDelegate?
    var commuteDelegate: CommuteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        API().getAllBus()
        // Contoh penggunaan API #ricky
        API().updateSchedule(trip_id: 1, stop_id: 1, time_arrival: "07:00:00")
        API().getScheduleByTrip(trip_id: 2)
        API().addCommute(user_id: 11, stop_id: 1, longitude: 101, latitude: 99, status_check: "go")
        
        locManager.delegate = self
        
        let tapBreeze = UITapGestureRecognizer(target: self, action: #selector(self.handleTapBreeze(_:)))
        let tapIce = UITapGestureRecognizer(target: self, action: #selector(handleTapIce(_:)))
        
        let (currLat, currLong) = getCurrentLatLong()
        
        getNearestStop(currLat: currLat, currLong: currLong) { (resStop) in
            DispatchQueue.main.async {
//                self.lblNearestStop.text = resStop
                stop = resStop
            }
        }
        
        BreezeIceView.layer.cornerRadius = 15
        IceBreezeView.layer.cornerRadius = 15
        
        contentArea.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentArea.layer.shadowOpacity = 0.15
        contentArea.layer.shadowRadius = 20
        contentArea.layer.cornerRadius = 20
        
        BreezeIceView.addGestureRecognizer(tapBreeze)
        IceBreezeView.addGestureRecognizer(tapIce)
        
        BreezeIceView.isUserInteractionEnabled = true
        IceBreezeView.isUserInteractionEnabled = true
    }
    
    func getNearestStop(currLat: CLLocationDegrees, currLong: CLLocationDegrees, completion: @escaping (_ stop: String) -> ()){
        // CloudKit
        
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
            
        if currentLocation == nil {
            return(0, 0)
        } else {
            let currLong = currentLocation.coordinate.longitude
            let currLat = currentLocation.coordinate.latitude
                
            return (currLat, currLong)
        }
    }
    
    func getNearestStopPergi(currLat: CLLocationDegrees, currLong: CLLocationDegrees, completion: @escaping (_ stop: String) -> ()){
        // CloudKit
        
        let currLocation = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let predicate = NSPredicate(format: "arah == %@", "pergi")
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
    
    func getNearestStopPulang(currLat: CLLocationDegrees, currLong: CLLocationDegrees, completion: @escaping (_ stop: String) -> ()){
        // CloudKit
        
        let currLocation = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let predicate = NSPredicate(format: "arah == %@", "pulang")
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
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret
    }
    
    @objc func handleTapBreeze(_ sender: UITapGestureRecognizer) {
//        let nextStoryboard = UIStoryboard(name: "NavDetailStoryboard", bundle: nil)
//        let nextVC = nextStoryboard.instantiateViewController(identifier: "NavDetailStoryboard") as NavDetailViewController
//        arah = "pergi"
//        rute = "BRE"
//        kendaraan = "BSDLink"
//        present(nextVC, animated: true, completion: nil)
        let (currLat, currLong) =  getCurrentLatLong()
        getNearestStopPergi(currLat: currLat, currLong: currLong) { (nearPergi) in
            self.getNearestStopPulang(currLat: currLat, currLong: currLong) { (nearPulang) in
                self.xibDelegate?.getTrip(trip: "BRE", nearPergi: nearPergi, nearPulang: nearPulang)
            }
        }
    }
    
    @objc func handleTapIce(_ sender: UITapGestureRecognizer) {
//        let nextStoryboard = UIStoryboard(name: "NavDetailStoryboard", bundle: nil)
//        let nextVC = nextStoryboard.instantiateViewController(identifier: "NavDetailStoryboard") as NavDetailViewController
//        arah = "pulang"
//        rute = "BRE"
//        kendaraan = "BSDLink"
//        present(nextVC, animated: true, completion: nil)
        let (currLat, currLong) =  getCurrentLatLong()
        getNearestStopPergi(currLat: currLat, currLong: currLong) { (nearPergi) in
            self.getNearestStopPulang(currLat: currLat, currLong: currLong) { (nearPulang) in
                self.xibDelegate?.getTrip(trip: "BRE", nearPergi: nearPergi, nearPulang: nearPulang)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let currLoc = locations.last
            let currLong = (currLoc?.coordinate.longitude)!
            let currLat = (currLoc?.coordinate.latitude)!
            
            getNearestStop(currLat: currLat, currLong: currLong) { (resStop) in
//                self.lblNearestStop.text = resStop
                stop = resStop
                
            }
        }
    }
}
