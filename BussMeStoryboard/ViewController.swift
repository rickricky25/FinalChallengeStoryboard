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
    var polyline:GMSPolyline!
    
    var mapView: GMSMapView!

    override func viewDidLoad() {
        let position = CLLocationCoordinate2D(latitude: 1.285, longitude: 103.848)
        let marker = GMSMarker(position: position)
        super.viewDidLoad()
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.backgroundColor = UIColor.red
        
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: 1.285, longitude: 103.848, zoom: 12)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        
        mapView.delegate = self
        
        marker.title = "Hello World"
        marker.map = mapView
        self.view.addSubview(mapView)
        
        
//        let coor2 = CLLocationCoordinate2D(latitude: 1.301, longitude: 103.829)
//
//        fetchRoute(from: coor1, to: coor2)
        
        imageView.center = mapView.center
        
        view.addSubview(imageView)
    }
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {

        let session = URLSession.shared

        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=AIzaSyD6cwj9tbrNCj4mXFzpfsSeJl--Yv0UntE")!

        let task = session.dataTask(with: url, completionHandler: {
            (data, response, err) in

            guard err == nil else {
                print(err!.localizedDescription)
                return
            }
            guard let unwrappedData = data else { return }
            do{
                let str = String(decoding: unwrappedData, as: UTF8.self)

                let json = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! [String:Any]
                let routes = json["routes"] as! [Any]
                let first = routes[0] as! [String:Any]
                let poly = first["overview_polyline"] as! [String:Any]
                let points = poly["points"] as! String
                DispatchQueue.main.async {
                    self.drawPath(from: points)
                }
                
            }catch{
                print(error)
            }

//            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any], let jsonResponse = jsonResult else {
//                print("error in JSONSerialization")
//                return
//            }
//
//            guard let routes = jsonResponse["routes"] as? [Any] else {
//                return
//            }
//
//            guard let route = routes[0] as? [String: Any] else {
//                return
//            }
//
//            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
//                return
//            }
//
//            guard let polyLineString = overview_polyline["points"] as? String else {
//                return
//            }
//
//            //Call this method to draw path on map
//            self.drawPath(from: polyLineString)
        })
        task.resume()
    }
    
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        
        polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView // Google MapView
        polyline.map = nil
    }

//    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        let center = mapView.center
//        let coor = mapView.projection.coordinate(for: center)
//        //print(coor.latitude, coor.longitude)
//
//        let address = CLGeocoder.init()
//        address.reverseGeocodeLocation(CLLocation.init(latitude: coor.latitude, longitude: coor.longitude)) { (places, error) in
//            if error == nil{
//                if let place = places{
//                    //print(place[0].name!)
//                    let distance = GMSGeometryDistance(coor, CLLocationCoordinate2D(latitude: 1.285, longitude: 103.848))
//                    print(coor)
//                    let coor1 = CLLocationCoordinate2D(latitude: 1.285, longitude: 103.848)
//                    self.fetchRoute(from: coor, to: coor1)
//                }
//            }
//        }
//    }
    
//    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
//        let center = mapView.center
//        let coor = mapView.projection.coordinate(for: center)
//        //print(coor.latitude, coor.longitude)
//
//        let address = CLGeocoder.init()
//        address.reverseGeocodeLocation(CLLocation.init(latitude: coor.latitude, longitude: coor.longitude)) { (places, error) in
//            if error == nil{
//                if let place = places{
//                    //print(place[0].name!)
//                    let distance = GMSGeometryDistance(coor, CLLocationCoordinate2D(latitude: 1.285, longitude: 103.848))
//                    print(coor)
//                    let coor1 = CLLocationCoordinate2D(latitude: 1.285, longitude: 103.848)
//                    self.fetchRoute(from: coor, to: coor1)
//                }
//            }
//        }
//    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let center = mapView.center
        let coor = mapView.projection.coordinate(for: center)
        //print(coor.latitude, coor.longitude)
        
        let address = CLGeocoder.init()
        address.reverseGeocodeLocation(CLLocation.init(latitude: coor.latitude, longitude: coor.longitude)) { (places, error) in
            if error == nil{
                if let place = places{
                    //print(place[0].name!)
                    let distance = GMSGeometryDistance(coor, CLLocationCoordinate2D(latitude: 1.285, longitude: 103.848))
                    print(coor)
                    let coor1 = CLLocationCoordinate2D(latitude: 1.285, longitude: 103.848)
                    self.fetchRoute(from: coor, to: coor1)
                }
            }
        }
    }
    
//    func mapView
    
}

