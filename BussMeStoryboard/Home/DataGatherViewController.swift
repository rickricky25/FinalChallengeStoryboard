//
//  DataGatherViewController.swift
//  BussMeStoryboard
//
//  Created by Ricky Effendi on 04/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import CoreLocation
import CloudKit

class DataGatherViewController: UIViewController, CLLocationManagerDelegate {
    
    var date = Date()
    var calendar: NSCalendar!
    var mapView: GMSMapView!
    var locManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.requestWhenInUseAuthorization()
        locManager.delegate = self
        locManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnCheckInPressed(_ sender: UIButton) {
        let newRecord = CKRecord(recordType: "DataGathering")
                
        calendar = NSCalendar.current as NSCalendar
        let currHour = calendar.component(.hour, from: date)
        let currMinute = calendar.component(.minute, from: date)
        let currSecond = calendar.component(.second, from: date)
        //        let currDay = calendar.component(.day, from: date)
        //        let currMonth = calendar.component(.month, from: date)
        //        let currYear = calendar.component(.year, from: date)
                
        (newRecord["latitude"], newRecord["longitude"]) = getCurrentLatLong()
        newRecord["time"] = "\(currHour):\(currMinute):\(currSecond)"
        newRecord["senderID"] = UIDevice.current.identifierForVendor?.uuidString
        newRecord["status"] = "Check In"
        
        let container = CKContainer.init(identifier: "iCloud.com.BussMeStoryboard")
        let publicDatabase = container.publicCloudDatabase
                
        publicDatabase.save(newRecord) { (record, error) in
            print(error)
        }
    }
    
    @IBAction func btnCheckOutPressed(_ sender: UIButton) {
        let newRecord = CKRecord(recordType: "DataGathering")
                
        date = Date()
        let currHour = calendar.component(.hour, from: date)
        let currMinute = calendar.component(.minute, from: date)
        let currSecond = calendar.component(.second, from: date)
        //        let currDay = calendar.component(.day, from: date)
        //        let currMonth = calendar.component(.month, from: date)
        //        let currYear = calendar.component(.year, from: date)
        
        (newRecord["latitude"], newRecord["longitude"]) = getCurrentLatLong()
        newRecord["time"] = "\(currHour):\(currMinute):\(currSecond)"
        newRecord["senderID"] = UIDevice.current.identifierForVendor?.uuidString
        newRecord["status"] = "Check Out"
        
        let container = CKContainer.init(identifier: "iCloud.com.BussMeStoryboard")
        let publicDatabase = container.publicCloudDatabase
                
        publicDatabase.save(newRecord) { (record, error) in
            print(error)
        }

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
}
