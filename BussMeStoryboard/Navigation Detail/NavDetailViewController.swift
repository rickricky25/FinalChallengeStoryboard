//
//  NavDetailViewController.swift
//  BussMeStoryboard
//
//  Created by Ricky Effendi on 12/11/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import CoreLocation
import CloudKit

class NavDetailViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    
    var mapView: GMSMapView!
    var locManager = CLLocationManager()
    var currMarker: GMSMarker!

    override func viewDidLoad() {
        super.viewDidLoad()

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

extension NavDetailViewController: CLLocationManagerDelegate {
    
}
