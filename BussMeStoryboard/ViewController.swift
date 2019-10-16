//
//  ViewController.swift
//  BussMeStoryboard
//
//  Created by Ricky Effendi on 15/10/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    override func viewDidLoad() {
        let position = CLLocationCoordinate2D(latitude: 1.285, longitude: 103.848)
        let marker = GMSMarker(position: position)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: 1.285, longitude: 103.848, zoom: 12)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        
        marker.title = "Hello World"
        marker.map = mapView
        self.view = mapView
    }


}

