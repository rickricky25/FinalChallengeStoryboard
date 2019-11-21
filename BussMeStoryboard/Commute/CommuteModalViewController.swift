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


var arah: String?
var rute: String?
var stop: String?
var kendaraan: String?

class CommuteModalViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var handleArea: UIView!
    @IBOutlet var contentArea: UIView!
    @IBOutlet weak var BreezeIceView: UIView!
    @IBOutlet weak var IceBreezeView: UIView!
    @IBOutlet weak var lblNearestStop: UILabel!
    
    var locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.delegate = self
        
        let tapBreeze = UITapGestureRecognizer(target: self, action: #selector(self.handleTapBreeze(_:)))
        let tapIce = UITapGestureRecognizer(target: self, action: #selector(handleTapIce(_:)))
        
        let (currLat, currLong) = getCurrentLatLong()
        stop = getNearestStop(currLat: currLat, currLong: currLong)
        lblNearestStop.text = stop
        
        BreezeIceView.layer.cornerRadius = 10
        IceBreezeView.layer.cornerRadius = 10
        
        contentArea.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentArea.layer.shadowOpacity = 0.1
        contentArea.layer.shadowRadius = 15
        contentArea.layer.cornerRadius = 25
        
        
        BreezeIceView.addGestureRecognizer(tapBreeze)
        IceBreezeView.addGestureRecognizer(tapIce)
        
        BreezeIceView.isUserInteractionEnabled = true
        IceBreezeView.isUserInteractionEnabled = true
    }
    
    func getNearestStop(currLat: CLLocationDegrees, currLong: CLLocationDegrees) -> String {
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
        }
        return nearestStop
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
    
    @objc func handleTapBreeze(_ sender: UITapGestureRecognizer) {
        let nextStoryboard = UIStoryboard(name: "NavDetailStoryboard", bundle: nil)
        let nextVC = nextStoryboard.instantiateViewController(identifier: "NavDetailStoryboard") as NavDetailViewController
        arah = "pergi"
        rute = "BRE"
        kendaraan = "BSDLink"
        present(nextVC, animated: true, completion: nil)
    }
    
    @objc func handleTapIce(_ sender: UITapGestureRecognizer) {
        let nextStoryboard = UIStoryboard(name: "NavDetailStoryboard", bundle: nil)
        let nextVC = nextStoryboard.instantiateViewController(identifier: "NavDetailStoryboard") as NavDetailViewController
        arah = "pulang"
        rute = "BRE"
        kendaraan = "BSDLink"
        present(nextVC, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let currLoc = locations.last
            let currLong = (currLoc?.coordinate.longitude)!
            let currLat = (currLoc?.coordinate.latitude)!
            
            stop = getNearestStop(currLat: currLat, currLong: currLong)
            lblNearestStop.text = stop
        }
    }
}
