//
//  HomeViewController.swift
//  BussMeStoryboard
//
//  Created by Mulyanti Law on 23/10/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import CoreLocation
import CloudKit

class HomeViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var MapView: UIView!
    @IBOutlet weak var BtnView: UIView!
    
    var date = Date()
    var calendar: NSCalendar!
    var pinView: UIImageView!
    var polyline: GMSPolyline!
    var mapView: GMSMapView!
    var locManager = CLLocationManager()
    var marker: GMSMarker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Getting Permission for Maps
        locManager.requestWhenInUseAuthorization()
        locManager.delegate = self
        locManager.startUpdatingLocation()
        
        //Making Marker of Current Location
        let (currLat, currLong) =  getCurrentLatLong()
        let position = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
        marker = GMSMarker(position: position)
//        marker.icon = 
        
        pinView = UIImageView(image: UIImage(named: "pin"))
        
        let camera = GMSCameraPosition.camera(withLatitude: currLat, longitude: currLong, zoom: 18)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        
        mapView.delegate = self
        
        marker.title = "Hello World"
        marker.map = mapView
        
        self.MapView.addSubview(mapView)
        self.MapView.addSubview(BtnView)
        
        pinView.center = mapView.center

        view.addSubview(pinView)
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        super.viewDidLoad()
//        //Getting Permission for Maps
//        locManager.requestWhenInUseAuthorization()
//        locManager.delegate = self
//
//        //Making Marker of Current Location
//        let (currLong, currLat) =  getCurrentLongLat()
//        let position = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
//        marker = GMSMarker(position: position)
//
//        pinView = UIImageView(image: UIImage(named: "pin"))
//
//        let camera = GMSCameraPosition.camera(withLatitude: currLat, longitude: currLong, zoom: 18)
//        mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
//
//        mapView.delegate = self
//
//        marker.title = "Hello World"
//        marker.map = mapView
//
//        self.MapView.addSubview(mapView)
//        self.MapView.addSubview(BtnView)
//
//        pinView.center = mapView.center
//
//        view.addSubview(pinView)
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let currLoc = locations.last
            let currLong = (currLoc?.coordinate.longitude)!
            let currLat = (currLoc?.coordinate.latitude)!
            
            let position = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
            marker.position = position
            
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

    @IBAction func btnInPress(_ sender: UIButton) {
        let newRecord = CKRecord(recordType: "Testing")
        
        calendar = NSCalendar.current as NSCalendar
        let currHour = calendar.component(.hour, from: date)
        let currMinute = calendar.component(.minute, from: date)
//        let currDay = calendar.component(.day, from: date)
//        let currMonth = calendar.component(.month, from: date)
//        let currYear = calendar.component(.year, from: date)
        
        (newRecord["Latitude"], newRecord["Longitude"]) = getCurrentLatLong()
        newRecord["Time"] = "\(currHour):\(currMinute)"
        
        print(newRecord["Latitude"])
        print(newRecord["Longitude"])
        let container = CKContainer.init(identifier: "iCloud.com.BussMeStoryboard")
        let publicDatabase = container.publicCloudDatabase
        
        publicDatabase.save(newRecord) { (record, error) in
            print(error)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
