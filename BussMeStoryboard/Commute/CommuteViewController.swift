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

protocol XibDelegate {
    func getTrip(trip: String)
}

class CommuteViewController: UIViewController, XibDelegate {
    func getTrip(trip: String) {
        UIView.animate(withDuration: 0.7) {
            self.commuteModalViewController.view.frame.origin.y = self.view.frame.height
            self.navDetailCardViewController.view.frame.origin.y = self.view.frame.height - 415
        }
    }
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var commuteTabBar: UITabBar!
    
    enum CardStateCommute {
        case expanded
        case collapsed
    }
    
    enum CardStateNavDetail {
        case expanded
        case collapsed
        case hide
    }
    
    var nextState: CardStateNavDetail {
        //        return cardNavDetailVisible ? .collapsed : .expanded
        if cardNavDetailVisible == 0 {
            print(0)
            return .hide
        } else if cardNavDetailVisible ==  1 {
            print(1)
            return .collapsed
        } else {
            print(2)
            return .expanded
        }
    }
    
    var commuteModalViewController: CommuteModalViewController!
    var navDetailCardViewController: NavDetailCardViewController!
    var visualEffectView:UIVisualEffectView!
    let cardHeight:CGFloat = 500
    let cardHandleAreaH:CGFloat = 250
    var cardNavDetailVisible = 0
    var cardCommuteVisible = 0
    var arahCard = ""
    var handleCard = ""
    
    var nextStateCommute: CardStateCommute {
        //        return cardCommuteVisible ? .collapsed : .expanded
        if cardCommuteVisible == 0 {
            return .collapsed
        } else {
            return .expanded
        }
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
            self.locManager.delegate = self
            DispatchQueue.global().async {
                self.locManager.requestWhenInUseAuthorization()
                self.locManager.startUpdatingLocation()
            }
            
            let (currLat, currLong) = getCurrentLatLong()
            let currLoc = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
            currMarker = GMSMarker(position: currLoc)
            currMarker.icon = UIImage(named: "pin")
            currMarker.title = "Current Location"
            
            let camera = GMSCameraPosition.camera(withLatitude: currLat, longitude: currLong, zoom: 18)
            mapView = GMSMapView.map(withFrame: mainView.frame, camera: camera)
            
            currMarker.map = mapView
            
            DispatchQueue.global().async {
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
            }
            self.mainView.addSubview(mapView)
            
            setupCardNavDetail()
            setupCardCommute()
            
            commuteModalViewController.delegate = self
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
            
            //            let predicate = NSPredicate(value: true)
            //            let query = CKQuery(recordType: "DataStop", predicate: predicate)
            //            let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
            //            let publicDatabase = container.publicCloudDatabase
            
            self.mainView.addSubview(mapView)
            //            setupCardCommute()
        }
    }
    
    //Function to get Current Location
    func getCurrentLatLong() -> (Double, Double) {
        var currentLocation: CLLocation!
        
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLocation = locManager.location
        }
        
        if currentLocation == nil {
            return(0, 0)
        } else {
            let currLong = currentLocation.coordinate.longitude
            let currLat = currentLocation.coordinate.latitude
            
            return (currLat, currLong)
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
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    
    //    **** MODAL FUNCTION COMMUTE ****
    func setupCardCommute() {
        //        visualEffectView = UIVisualEffectView()
        //        visualEffectView.frame = self.view.frame
        
        //        self.view.addSubview(visualEffectView)
        
        
        commuteModalViewController = CommuteModalViewController(nibName: "CommuteModalViewController", bundle:nil)
        self.addChild(commuteModalViewController)
        self.view.addSubview(commuteModalViewController.view)
        
        commuteModalViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaH - 110, width: self.view.bounds.width, height: cardHeight)
        
        commuteModalViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommuteViewController.handleCardCommuteTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CommuteViewController.handleCardCommutePan(recognizer:)))
        
        commuteModalViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        commuteModalViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    @objc
    func handleCardCommuteTap(recognizer: UITapGestureRecognizer) {
        print(cardCommuteVisible)
        print(nextStateCommute)
        handleCard = "tap"
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeededCommute(state: nextStateCommute, duration: 0.65)
        default:
            break
        }
        
    }
    @objc
    func handleCardCommutePan(recognizer: UIPanGestureRecognizer) {
        print(cardCommuteVisible)
        print(nextStateCommute)
        handleCard = "pan"
        switch recognizer.state {
        case .began:
            print("began")
        case .changed:
            let translation = recognizer.translation(in: self.commuteModalViewController.handleArea)
            let velocity = recognizer.velocity(in: self.commuteModalViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            //            fractionComplete = cardCommuteVisible ? fractionComplete : -fractionComplete
            //            if cardCommuteVisible == 1 {
            //                fractionComplete = -fractionComplete
            //            }
            if velocity.y > 0 {
                arahCard = "turun"
                
                if cardCommuteVisible == 0 {
                    startInteractiveTransitionCommute(state: .collapsed, duration: 0.3)
                }
            } else {
                arahCard = "naik"
                fractionComplete = -fractionComplete
                
                if cardCommuteVisible == 1 {
                    startInteractiveTransitionCommute(state: .expanded, duration: 0.3)
                }
            }
            print(arahCard)
            updateInteractiveTransitionCommute(fractionCompleted: fractionComplete)
        case .ended:
            if cardCommuteVisible == 1 {
                cardCommuteVisible = 0
            } else {
                cardCommuteVisible = 1
            }
            continueInteractiveTransitionCommute()
        default:
            break
        }
    }
    
    func animateTransitionIfNeededCommute(state: CardStateCommute, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 15) {
                switch state {
                case .expanded:
                    self.commuteModalViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight + 50
                case .collapsed:
                    self.commuteModalViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaH + 50
                    
                }
            }
            
            frameAnimator.addCompletion { _ in
                //                self.cardCommuteVisible = !self.cardCommuteVisible
                //                if self.cardCommuteVisible == 0 {
                //                    self.cardCommuteVisible = 1
                //                } else if self.cardCommuteVisible == 1 {
                //                    self.cardCommuteVisible = 0
                //                }
                print(self.handleCard)
                if self.handleCard == "tap" {
                    if self.cardCommuteVisible == 0 {
                        self.cardCommuteVisible = 1
                    } else if self.cardCommuteVisible == 1 {
                        self.cardCommuteVisible = 0
                    }
                } else {
                    if self.arahCard == "naik" {
                        self.cardCommuteVisible = 0
                    } else if self.arahCard == "turun" {
                        self.cardCommuteVisible = 1
                    }
                }
                
                if let index = self.runningAnimations.firstIndex(of: frameAnimator){
                    self.runningAnimations.remove(at: index)
                }
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                switch state {
                case .expanded:
                    self.commuteModalViewController.view.layer.cornerRadius = 20
                case .collapsed:
                    self.commuteModalViewController.view.layer.cornerRadius = 0
                }
            }
            
            cornerRadiusAnimator.addCompletion { (_) in
                if let index = self.runningAnimations.firstIndex(of: cornerRadiusAnimator){
                    self.runningAnimations.remove(at: index)
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
        }
    }
    
    func startInteractiveTransitionCommute(state:CardStateCommute, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeededCommute(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressInterrupted = Int(animator.fractionComplete)
        }
    }
    
    func updateInteractiveTransitionCommute(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + CGFloat(animationProgressInterrupted)
        }
    }
    
    func continueInteractiveTransitionCommute (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    //    ******
    
    // MODAL CARD NAV DETAIL
    func setupCardNavDetail() {
        
        navDetailCardViewController = NavDetailCardViewController(nibName: "NavDetailCardViewController", bundle: nil)
        self.addChild(navDetailCardViewController)
        self.view.addSubview(navDetailCardViewController.view)
        
        navDetailCardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.bounds.width, height: cardHeight)
        
        navDetailCardViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NavDetailViewController.handleCardNavDetailTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(NavDetailViewController.handleCardNavDetailPan(recognizer:)))
        
        navDetailCardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        navDetailCardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc
    func handleCardNavDetailTap(recognizer:UITapGestureRecognizer) {
        handleCard = "tap"
        print("tapped")
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeededNavDetail(state: nextState, duration: 0.65)
        default:
            break
        }
        
    }
    @objc
    func handleCardNavDetailPan (recognizer:UIPanGestureRecognizer) {
        handleCard = "pan"
        switch recognizer.state {
        case .began:
            //            startInteractiveTransitionCommute(state: nextState, duration: 0.35)
            print("began\(cardNavDetailVisible)")
        case .changed:
            let translation = recognizer.translation(in: self.navDetailCardViewController.handleArea)
            let velocity = recognizer.velocity(in: self.navDetailCardViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            //            fractionComplete = cardNavDetailVisible ? fractionComplete : -fractionComplete
            //            if cardNavDetailVisible == 2 {
            //                fractionComplete = -fractionComplete
            //            }
            if velocity.y > 0 {
                arahCard = "turun"
                fractionComplete = -fractionComplete
                if cardNavDetailVisible == 0 {
                    //                    self.startInteractiveTransitionCommute(state: .hide, duration: 0.35)
                    print("hide")
                } else if cardNavDetailVisible == 1 {
                    self.startInteractiveTransitionNavDetail(state: .hide, duration: 0.35)
                    print("hide")
                } else if cardNavDetailVisible == 2 {
                    self.startInteractiveTransitionNavDetail(state: .collapsed, duration: 0.35)
                    print("collapsed")
                }
                
            } else {
                arahCard = "naik"
                if cardNavDetailVisible == 0 {
                    self.startInteractiveTransitionNavDetail(state: .collapsed, duration: 0.35)
                    print("collapsed")
                } else if cardNavDetailVisible == 1 {
                    self.startInteractiveTransitionNavDetail(state: .expanded, duration: 0.35)
                    print("expanded")
                } else if cardNavDetailVisible == 2 {
                    //                    self.startInteractiveTransitionCommute(state: .expanded, duration: 0.35)
                    print("expanded")
                }
                //                print("naik")
            }
            updateInteractiveTransitionNavDetail(fractionCompleted: fractionComplete)
        //            print("changed")
        case .ended:
            continueInteractiveTransitionNavDetail()
        //            print("ended")
        default:
            break
        }
    }
    
    func animateTransitionIfNeededNavDetail (state: CardStateNavDetail, duration: TimeInterval) {
        print("animateIfNeeded")
        
        
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 5) {
                switch state {
                case .expanded:
                    self.navDetailCardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight + 35
                case .collapsed:
                    self.navDetailCardViewController.view.frame.origin.y = self.view.frame.height - 415
                case .hide:
                    self.navDetailCardViewController.view.frame.origin.y = self.view.frame.height - 300
                }
            }
            
            frameAnimator.addCompletion { _ in
                if self.handleCard == "pan" {
                    if self.arahCard == "naik" {
                        switch self.cardNavDetailVisible {
                        case 0:
                            self.cardNavDetailVisible = 1
                        case 1:
                            self.cardNavDetailVisible = 2
                        case 2:
                            self.cardNavDetailVisible = 2
                        default:
                            print("error")
                        }
                    } else if self.arahCard == "turun" {
                        switch self.cardNavDetailVisible {
                        case 0:
                            self.cardNavDetailVisible = 0
                        case 1:
                            self.cardNavDetailVisible = 0
                        case 2:
                            self.cardNavDetailVisible = 1
                        default:
                            print("error")
                        }
                    }
                } else {
                    if self.cardNavDetailVisible == 0 {
                        self.cardNavDetailVisible = 1
                    } else if self.cardNavDetailVisible == 1 {
                        self.cardNavDetailVisible = 2
                    } else {
                        self.cardNavDetailVisible = 1
                    }
                }
                if let index = self.runningAnimations.firstIndex(of: frameAnimator){
                    self.runningAnimations.remove(at: index)
                }
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
                switch state {
                case .expanded:
                    self.navDetailCardViewController.view.layer.cornerRadius = 25
                case .collapsed:
                    self.navDetailCardViewController.view.layer.cornerRadius = 0
                case .hide:
                    self.navDetailCardViewController.view.layer.cornerRadius = 25
                }
            }
            cornerRadiusAnimator.addCompletion { (_) in
                if let index = self.runningAnimations.firstIndex(of: cornerRadiusAnimator){
                    self.runningAnimations.remove(at: index)
                }
            }
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
        }
    }
    
    func startInteractiveTransitionNavDetail(state:CardStateNavDetail, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeededNavDetail(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressInterrupted = Int(animator.fractionComplete)
        }
    }
    
    func updateInteractiveTransitionNavDetail(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + CGFloat(animationProgressInterrupted)
        }
    }
    
    func continueInteractiveTransitionNavDetail() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
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
