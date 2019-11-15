//
//  CommuteViewController.swift
//  BussMeStoryboard
//
//  Created by Ricky Effendi on 11/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import CoreLocation
import CloudKit

class CommuteViewController: UIViewController {
    @IBOutlet var mainView: UIView!
    
//    **** .xib View Commuter
    @IBOutlet weak var contentArea: UIView!
    @IBOutlet weak var handlerArea: UIView!
//    ************
    
    var mapView: GMSMapView!
    var locManager = CLLocationManager()
    var currMarker: GMSMarker!
    var nearestDist: Double!
    var nearestLoc: CLLocationCoordinate2D!
    var nearestStop: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Card View
        style()
        
        //Getting Permission for Maps
        locManager.requestWhenInUseAuthorization()
        locManager.delegate = self
        locManager.startUpdatingLocation()
        
        let (currLat, currLong) = getCurrentLatLong()
        let currLoc = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
        currMarker = GMSMarker(position: currLoc)
        currMarker.icon = UIImage(named: "pin")
        currMarker.title = "Current Location"
        
        let camera = GMSCameraPosition.camera(withLatitude: currLat, longitude: currLong, zoom: 18)
        mapView = GMSMapView.map(withFrame: mainView.frame, camera: camera)
        
        currMarker.map = mapView
        
        
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "DataStop", predicate: predicate)
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let publicDatabase = container.publicCloudDatabase
        
        publicDatabase.perform(query, inZoneWith: nil) { (hasil, error) in
            for i in 0...hasil!.count - 1 {
                guard let lati = hasil![i]["latitude"]! as? String, let longi = hasil![i]["longitude"] as? String else { return }
                let latDouble: Double = Double(lati)!
                let longDouble: Double = Double(longi)!
                
                DispatchQueue.main.async {
                    let stopLoc = CLLocationCoordinate2D(latitude: latDouble, longitude: longDouble)
                    if i == 0 {
                        self.nearestDist = GMSGeometryDistance(stopLoc, currLoc)
                        self.nearestStop = hasil![i]["namaStop"]
                        self.nearestLoc = stopLoc
                        print(self.nearestStop)
                    } else {
                        let distance = GMSGeometryDistance(stopLoc, currLoc)
                        if distance < self.nearestDist {
                            self.nearestLoc = stopLoc
                            self.nearestStop = hasil![i]["namaStop"]
                            self.nearestDist = distance
                            print(self.nearestStop)
                        }
                    }
                    
                    let stopMarker = GMSMarker(position: stopLoc)
                    stopMarker.title = hasil![i]["namaStop"]
                    stopMarker.map = self.mapView
                }
            }
        }
        
         self.mainView.addSubview(mapView)
    }
    
    //Function Style for Card View
    func style(){
//        contentArea.layer.cornerRadius = 1
//        contentArea.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    //Function to get Current Location
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

extension CommuteViewController: GMSMapViewDelegate {
    
}

extension CommuteViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let currLoc = locations.last
            let currLong = (currLoc?.coordinate.longitude)!
            let currLat = (currLoc?.coordinate.latitude)!
            
            let position = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
            currMarker.position = position
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
    }
}
