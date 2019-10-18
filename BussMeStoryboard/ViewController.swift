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
    
    var imageView:UIImageView!

    override func viewDidLoad() {
        let position = CLLocationCoordinate2D(latitude: 1.285, longitude: 103.848)
        let marker = GMSMarker(position: position)
        super.viewDidLoad()
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.backgroundColor = UIColor.red
        
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: 1.285, longitude: 103.848, zoom: 12)
        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        
        mapView.delegate = self
        
        marker.title = "Hello World"
        marker.map = mapView
        self.view.addSubview(mapView)
        
        imageView.center = mapView.center
        
        view.addSubview(imageView)
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

