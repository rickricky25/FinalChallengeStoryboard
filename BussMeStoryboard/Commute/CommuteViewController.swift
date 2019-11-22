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
import SystemConfiguration

class CommuteViewController: UIViewController {
    @IBOutlet var mainView: UIView!
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    var commuteModalViewController:CommuteModalViewController!
    var visualEffectView:UIVisualEffectView!
    let cardHeight:CGFloat = 500
    let cardHandleAreaH:CGFloat = 250
    var cardVisible = false
    
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressInterrupted = 0
    
    //MAP----------------------
    var mapView: GMSMapView!
    var locManager = CLLocationManager()
    var currMarker: GMSMarker!
    var nearestDist: Double!
    var nearestLoc: CLLocationCoordinate2D!
    var nearestStop: String!
    
    override func viewDidLoad() {
        if isConnectedToNetwork() {
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
                            print(self.nearestStop ?? "Unknown")
                        } else {
                            let distance = GMSGeometryDistance(stopLoc, currLoc)
                            if distance < self.nearestDist {
                                self.nearestLoc = stopLoc
                                self.nearestStop = hasil![i]["namaStop"]
                                self.nearestDist = distance
                                print(self.nearestStop ?? "Unknown")
                            }
                        }
                        
                        let stopMarker = GMSMarker(position: stopLoc)
                        stopMarker.title = hasil![i]["namaStop"]
                        stopMarker.map = self.mapView
                    }
                }
            }
            self.mainView.addSubview(mapView)
            setupCard()
        } else {
            // Coding tanpa internet
            super.viewDidLoad()
            //Getting Permission for Maps
            locManager.requestWhenInUseAuthorization()
            locManager.delegate = self
            locManager.startUpdatingLocation()
            
            let currLat = -6.3013655304179
            let currLong = 106.653071772344
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
            
            self.mainView.addSubview(mapView)
//            setupCard()
        }
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
    
//    **** MODAL FUNCTION ****
    func setupCard() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        
        self.view.addSubview(visualEffectView)
        
        commuteModalViewController = CommuteModalViewController(nibName: "CommuteModalViewController", bundle:nil)
        self.addChild(commuteModalViewController)
        self.view.addSubview(commuteModalViewController.view)
        
        commuteModalViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaH - 20, width: self.view.bounds.width, height: cardHeight)
        
        commuteModalViewController.view.clipsToBounds = true
                
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommuteViewController.handleCardTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CommuteViewController.handleCardPan(recognizer:)))
        
        commuteModalViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        commuteModalViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
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
            let translation = recognizer.translation(in: self.commuteModalViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired

        return isReachable && !needsConnection
        */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret
    }
    
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 5) {
                switch state {
                case .expanded:
                    self.commuteModalViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.commuteModalViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaH - 20
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
                    self.commuteModalViewController.view.layer.cornerRadius = 25
                case .collapsed:
                    self.commuteModalViewController.view.layer.cornerRadius = 0
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
    
//    ******
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
