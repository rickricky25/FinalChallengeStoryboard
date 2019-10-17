//
//  ViewController.swift
//  BussMeStoryboard
//
//  Created by Ricky Effendi on 15/10/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import CoreLocation

class ViewController: UIViewController, GMSMapViewDelegate {

    override func viewDidLoad() {
        let position = CLLocationCoordinate2D(latitude: 1.285, longitude: 103.848)
        let marker = GMSMarker(position: position)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: 1.285, longitude: 103.848, zoom: 12)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        
        mapView.delegate = self
        
        marker.title = "Hello World"
        marker.map = mapView
        self.view = mapView
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let center = mapView.center
        let coor = mapView.projection.coordinate(for: center)
        //print(coor.latitude, coor.longitude)
        
        let address = CLGeocoder.init()
        address.reverseGeocodeLocation(CLLocation.init(latitude: coor.latitude, longitude: coor.longitude)) { (places, error) in
            if error == nil{
                if let place = places{
                    print(place[0].name!)
                }
            }
        }
    }
    
}

