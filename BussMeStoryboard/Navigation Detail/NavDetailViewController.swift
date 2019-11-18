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
    
//    *** MODAL ***
    enum CardState {
        case expanded
        case collapsed
    }
    
    var navDetailCardViewController: NavDetailCardViewController!
    var visualEffectView: UIVisualEffectView!
    let cardHeight: CGFloat = 500
    let cardHandleAreaH: CGFloat = 250
    var cardVisible = false
    
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressInterrupted = 0
//    *******
    
    var mapView: GMSMapView!
    var locManager = CLLocationManager()
    var currMarker: GMSMarker!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Getting Permission for Maps
        locManager.requestWhenInUseAuthorization()
        locManager.delegate = self
        locManager.startUpdatingLocation()
        
        let (currLat, currLong) = getCurrentLatLong()
        let currLoc = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
        currMarker = GMSMarker(position: currLoc)
        currMarker.icon = UIImage(named: "oval")
        currMarker.title = "Current Location"
        
        let camera = GMSCameraPosition.camera(withLatitude: currLat, longitude: currLong, zoom: 18)
        mapView = GMSMapView.map(withFrame: mainView.frame, camera: camera)
        
        currMarker.map = mapView
        
        let routePredicate = NSPredicate(format: "arah == %@ AND kodeRute == %@", "pergi", "BRE")
        let query = CKQuery(recordType: "DataRoute", predicate: routePredicate)
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let publicDatabase = container.publicCloudDatabase

        publicDatabase.perform(query, inZoneWith: nil) { (result, error) in
            if result?.count == 1 {
                var found = false
                let resStop = result![0]["namaStop"] as? [String]
                let resLat = result![0]["latStop"] as? [CLLocationDegrees]
                let resLong = result![0]["longStop"] as? [CLLocationDegrees]

                for i in 0...resStop!.count - 2 {
                    if found == false {
                        if resStop![i] == "The Breeze" {
                            print(resStop![i])
                            found = true
                            let firstLoc = CLLocationCoordinate2D(latitude: resLat![i], longitude: resLong![i])
                            let secondLoc = CLLocationCoordinate2D(latitude: resLat![i + 1], longitude: resLong![i + 1])
                            let stopMarker = GMSMarker(position: firstLoc)
                            stopMarker.title  = resStop![i]
                            stopMarker.icon = UIImage(named: "halte")
                            stopMarker.map = self.mapView
                            self.drawRoute(from: firstLoc, to: secondLoc)
                        }
                    } else {
                        print(resStop![i])
                        let firstLoc = CLLocationCoordinate2D(latitude: resLat![i], longitude: resLong![i])
                        let secondLoc = CLLocationCoordinate2D(latitude: resLat![i + 1], longitude: resLong![i + 1])
                        let stopMarker = GMSMarker(position: firstLoc)
                        stopMarker.title  = resStop![i]
                        stopMarker.icon = UIImage(named: "halte")
                        stopMarker.map = self.mapView
                        self.drawRoute(from: firstLoc, to: secondLoc)
                    }
                }
                
                let stopMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: resLat![resStop!.count - 1], longitude: resLong![resStop!.count - 1]))
                stopMarker.title = resStop![resStop!.count - 1]
                stopMarker.map = self.mapView
            }
        }
        
        self.mainView.addSubview(mapView)
        setupCard()
    }
    
    // Function to get Current Location
    func getCurrentLatLong() -> (Double, Double) {
        var currentLocation: CLLocation!
               
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLocation = locManager.location
        }
               
        let currLong = currentLocation.coordinate.longitude
        let currLat = currentLocation.coordinate.latitude
            
        return (currLat, currLong)
    }
    
    // Function to draw route from current stop
    func drawRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
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
//                let str = String(decoding: unwrappedData, as: UTF8.self)
                
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
        })
        task.resume()
    }
    
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 10
        polyline.strokeColor = UIColor(displayP3Red: 171/255, green: 49/255, blue: 181/255, alpha: 1)
        polyline.map = mapView // Google MapView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let currLoc = locations.last
            let currLong = (currLoc?.coordinate.longitude)!
            let currLat = (currLoc?.coordinate.latitude)!
            
            let position = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
            currMarker.position = position
        }
    }
    
    // Function to get nearest stop
    /*func getNearestStop(completion:(Void ->)) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "DataStop", predicate: predicate)
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let publicDatabase = container.publicCloudDatabase
        
        publicDatabase.perform(query, inZoneWith: nil) { (hasilStop, error) in
            let (currLat, currLong) = self.getCurrentLatLong()
            let currLoc = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
            
            var nearestLoc = CLLocationCoordinate2D(latitude: hasilStop![0]["latitude"]!, longitude: hasilStop![0]["longitude"]!)
            var nearestDist = GMSGeometryDistance(currLoc, nearestLoc)
            
            for i in 1...hasilStop!.count {
                let stopLoc = CLLocationCoordinate2D(latitude: hasilStop![i]["latitude"]!, longitude: hasilStop![i]["longitude"]!)
                let stopDist = GMSGeometryDistance(currLoc, stopLoc)
                if stopDist < nearestDist {
                    nearestLoc = stopLoc
                    nearestDist = stopDist
                }
            }
            return nearestLoc
        }
    }*/

//    **** MODAL FUNCTION ****
    func setupCard() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        navDetailCardViewController = NavDetailCardViewController(nibName: "NavDetailCardViewController", bundle: nil)
        self.addChild(navDetailCardViewController)
        self.view.addSubview(navDetailCardViewController.view)
        
        navDetailCardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaH, width: self.view.bounds.width, height: cardHeight)
        
        navDetailCardViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NavDetailViewController.handleCardTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(NavDetailViewController.handleCardPan(recognizer:)))
        
        navDetailCardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        navDetailCardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
    }

    @objc
    func handleCardTap(recognizer:UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.65)
        default:
            break
        }
        
    }
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.35)
        case .changed:
            let translation = recognizer.translation(in: self.navDetailCardViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 5) {
                switch state {
                case .expanded:
                    self.navDetailCardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.navDetailCardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaH
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
                switch state {
                case .expanded:
                    self.navDetailCardViewController.view.layer.cornerRadius = 25
                case .collapsed:
                    self.navDetailCardViewController.view.layer.cornerRadius = 0
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
        }
    }
    
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressInterrupted = Int(animator.fractionComplete)
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + CGFloat(animationProgressInterrupted)
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
//    ***********
}

extension NavDetailViewController: CLLocationManagerDelegate {
    
}
