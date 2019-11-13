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
        
        let alert = UIAlertController(title: "Alert", message: "Check In?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            if action.style == .cancel {
                print("cancel")
            } else {
                print("elsec")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if action.style == .default {
                let newRecord = CKRecord(recordType: "DataGathering")
        
                self.calendar = NSCalendar.current as NSCalendar
                let currHour = self.calendar.component(.hour, from: self.date)
                let currMinute = self.calendar.component(.minute, from: self.date)
                let currSecond = self.calendar.component(.second, from: self.date)
                        //        let currDay = calendar.component(.day, from: date)
                        //        let currMonth = calendar.component(.month, from: date)
                        //        let currYear = calendar.component(.year, from: date)
                
                (newRecord["latitude"], newRecord["longitude"]) = self.getCurrentLatLong()
                newRecord["time"] = "\(currHour):\(currMinute):\(currSecond)"
                newRecord["senderID"] = UIDevice.current.identifierForVendor?.uuidString
                newRecord["status"] = "Check In"
        
                let container = CKContainer.init(identifier: "iCloud.com.BussMeStoryboard")
                let publicDatabase = container.publicCloudDatabase
                
                publicDatabase.save(newRecord) { (record, error) in
                    print(error)
                }
            } else {
                print("elsed")
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnCheckOutPressed(_ sender: UIButton) {
         let alert = UIAlertController(title: "Alert", message: "Check Out?", preferredStyle: .alert)
               
               alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                   if action.style == .cancel {
                       print("cancel")
                   } else {
                       print("elsec")
                   }
               }))
               
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                   if action.style == .default {
                       let newRecord = CKRecord(recordType: "DataGathering")
               
                       self.calendar = NSCalendar.current as NSCalendar
                       let currHour = self.calendar.component(.hour, from: self.date)
                       let currMinute = self.calendar.component(.minute, from: self.date)
                       let currSecond = self.calendar.component(.second, from: self.date)
                               //        let currDay = calendar.component(.day, from: date)
                               //        let currMonth = calendar.component(.month, from: date)
                               //        let currYear = calendar.component(.year, from: date)
                       
                       (newRecord["latitude"], newRecord["longitude"]) = self.getCurrentLatLong()
                       newRecord["time"] = "\(currHour):\(currMinute):\(currSecond)"
                       newRecord["senderID"] = UIDevice.current.identifierForVendor?.uuidString
                       newRecord["status"] = "Check Out"
               
                       let container = CKContainer.init(identifier: "iCloud.com.BussMeStoryboard")
                       let publicDatabase = container.publicCloudDatabase
                       
                       publicDatabase.save(newRecord) { (record, error) in
                           print(error)
                       }
                   } else {
                       print("elsed")
                   }
               }))
               
               self.present(alert, animated: true, completion: nil)
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
