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
    func getTrip(trip: String, nearPergi: String, nearPulang: String)
    func navBackPressed()
    func naikBtnPressed(rute: String, arah: String)
    func navSegmentedSelected(index: Int)
    func turunBtnPressed()
    func turunChoicePressed(index: Int)
}

protocol CommuteDelegate {
    func navDetaiPressed(nearPergi: String, nearPulang: String)
}

class CommuteViewController: UIViewController, XibDelegate {
    func turunChoicePressed(index: Int) {
        if index == 1 {
            mapView.clear()
            UIView.animate(withDuration: 0.6) {
                self.commuteNaikModalViewController.view.frame.origin.y = self.view.frame.height
                self.commuteModalViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight + 50
                
                self.tabBarController?.tabBar.layer.zPosition = 0
                
                DispatchQueue.global().async {
                    // CloudKit
                    
                    let predicate = NSPredicate(value: true)
                    let query = CKQuery(recordType: "DataStop", predicate: predicate)
                    let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
                    let publicDatabase = container.publicCloudDatabase
                    
                    let (currLat, currLong) = self.getCurrentLatLong()
                    let currLoc = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
                    
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
                                stopMarker.icon = UIImage(named: "halte")
                                stopMarker.map = self.mapView
                            }
                        }
                    }
                }
            }
        }
    }
    
    func turunBtnPressed() {
        DispatchQueue.main.async {
            let nextStoryboard = UIStoryboard(name: "popUpTurun", bundle: nil)
            let nextVC = nextStoryboard.instantiateViewController(identifier: "popUpTurunStoryboard") as popUpTurunViewController
            
            nextVC.delegate = self
            
            self.present(nextVC, animated: true, completion: nil)
        }
    }
    
    func navSegmentedSelected(index: Int) {
        if index == 0 {
            arah = "pergi"
            self.mapView.animate(toLocation: self.locPergi!)
            self.mapView.animate(toZoom: 16)
            
            stop = nearPergi
            
            navDetailCardViewController.kodeRute.text = "Breeze - ICE"
            navDetailCardViewController.lblShortestTime1.text = "\(selPergi!)"
            navDetailCardViewController.lblShortestTime2.text = "\(selPergi! + 15)"
            navDetailCardViewController.lblShortestTime3.text = "\(selPergi! + 30)"
            
            self.navDetailCardViewController.lblStop.text = nearPergi
            
            navDetailCardViewController.lblStop1.text = routePergi[0]
            navDetailCardViewController.lblStop2.text = routePergi[1]
            navDetailCardViewController.lblStop3.text = routePergi[2]
            navDetailCardViewController.lblStop4.text = routePergi[3]
            navDetailCardViewController.lblStop5.text = routePergi[4]
            navDetailCardViewController.lblStop6.text = routePergi[5]
            navDetailCardViewController.lblStop7.text = routePergi[6]
            navDetailCardViewController.lblStop8.text = routePergi[7]
            
            navDetailCardViewController.lblTime1.text = waktuPergi[0]
            navDetailCardViewController.lblTime2.text = waktuPergi[1]
            navDetailCardViewController.lblTime3.text = waktuPergi[2]
            navDetailCardViewController.lblTime4.text = waktuPergi[3]
            navDetailCardViewController.lblTime5.text = waktuPergi[4]
            navDetailCardViewController.lblTime6.text = waktuPergi[5]
            navDetailCardViewController.lblTime7.text = waktuPergi[6]
            navDetailCardViewController.lblTime8.text = waktuPergi[7]
        } else if index == 1 {
            arah = "pulang"
            self.mapView.animate(toLocation: self.locPulang!)
            self.mapView.animate(toZoom: 16)
            
            stop = nearPulang
            
            navDetailCardViewController.kodeRute.text = "ICE - Breeze"
            navDetailCardViewController.lblShortestTime1.text = "\(selPulang!)"
            navDetailCardViewController.lblShortestTime2.text = "\(selPulang! + 15)"
            navDetailCardViewController.lblShortestTime3.text = "\(selPulang! + 30)"
            
            self.navDetailCardViewController.lblStop.text = nearPulang
            
            navDetailCardViewController.lblStop1.text = routePulang[0]
            navDetailCardViewController.lblStop2.text = routePulang[1]
            navDetailCardViewController.lblStop3.text = routePulang[2]
            navDetailCardViewController.lblStop4.text = routePulang[3]
            navDetailCardViewController.lblStop5.text = routePulang[4]
            navDetailCardViewController.lblStop6.text = routePulang[5]
            navDetailCardViewController.lblStop7.text = routePulang[6]
            navDetailCardViewController.lblStop8.text = routePulang[7]
            
            navDetailCardViewController.lblTime1.text = waktuPulang[0]
            navDetailCardViewController.lblTime2.text = waktuPulang[1]
            navDetailCardViewController.lblTime3.text = waktuPulang[2]
            navDetailCardViewController.lblTime4.text = waktuPulang[3]
            navDetailCardViewController.lblTime5.text = waktuPulang[4]
            navDetailCardViewController.lblTime6.text = waktuPulang[5]
            navDetailCardViewController.lblTime7.text = waktuPulang[6]
            navDetailCardViewController.lblTime8.text = waktuPulang[7]
        }
    }
    
    var selPergi: Int!
    var selPulang: Int!
    var waktuPergi: [String] = []
    var waktuPulang: [String] = []
    
    var routePergi: [String] = []
    var routePulang: [String] = []
    var locManager = CLLocationManager()
    var nearPulang: String = ""
    var nearPergi: String = ""
    
    var locPergi: CLLocationCoordinate2D?
    var locPulang: CLLocationCoordinate2D?
    
    func getCoorPergiPulang(nearPergi: String, nearPulang: String, completion: @escaping (_ locPergi: CLLocationCoordinate2D, _ locPulang: CLLocationCoordinate2D) -> ()) {
        // CloudKit
        
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let publicDatabase = container.publicCloudDatabase
        
        let predicatePergi = NSPredicate(format: "namaStop == %@", nearPergi)
        let predicatePulang = NSPredicate(format: "namaStop == %@", nearPulang)
        let queryPergi = CKQuery(recordType: "DataStop", predicate: predicatePergi)
        let queryPulang = CKQuery(recordType: "DataStop", predicate: predicatePulang)
        
        var latPergi: String?
        var longPergi: String?
        
        var latPulang: String?
        var longPulang: String?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {
            
            publicDatabase.perform(queryPergi, inZoneWith: nil) { (resPergi, error) in
                print(error as Any)
                for res in resPergi! {
                    print("location pergi: \(res["latitude"]!)")
                    latPergi = res["latitude"]!
                    longPergi = res["longitude"]!
                }
                semaphore.signal()
            }
            semaphore.wait(timeout: .distantFuture)
            
            publicDatabase.perform(queryPulang, inZoneWith: nil) { (resPulang, error) in
                for res in resPulang! {
                    print("location pulang: \(res["latitude"]!)")
                    latPulang = res["latitude"]!
                    longPulang = res["longitude"]!
                }
                semaphore.signal()
            }
            semaphore.wait(timeout: .distantFuture)
            
            let locPergi = CLLocationCoordinate2D(latitude: Double(latPergi!)!, longitude: Double(longPergi!)!)
            let locPulang = CLLocationCoordinate2D(latitude: Double(latPulang!)!, longitude: Double(longPulang!)!)

            completion(locPergi, locPulang)
        }
    }
    
    
    func getTrip(trip: String, nearPergi: String, nearPulang: String) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.6) {
                self.mapView.animate(toZoom: 16)
                self.commuteModalViewController.view.frame.origin.y = self.view.frame.height
                self.navDetailCardViewController.view.frame.origin.y = self.view.frame.height - 460
            }
        }
        DispatchQueue.global().async {
            self.getCoorPergiPulang(nearPergi: nearPergi, nearPulang: nearPulang) { (locPergiRes, locPulangRes) in
                DispatchQueue.main.async {
                    self.locPergi = locPergiRes
                    self.locPulang = locPulangRes
                    if self.navDetailCardViewController.arahSegmentedControl.selectedSegmentIndex == 0 {
                        self.mapView.animate(toLocation: locPergiRes)
                    } else {
                        self.mapView.animate(toLocation: locPulangRes)
                    }
                }
            }
        }
        
        self.nearPergi = nearPergi
        self.nearPulang = nearPulang
        
        // CloudKit
        
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(format: "kodeRute == %@", rute)
        let query = CKQuery(recordType: "DataRoute", predicate: predicate)
        
        var resultRoute: [CKRecord] = []
        
        getShortestTime(rute: rute) { (selisihPergi, selisihPulang, timesPergi, timesPulang) in
            self.selPergi = selisihPergi
            self.selPulang = selisihPulang
            self.waktuPergi = timesPergi
            self.waktuPulang = timesPulang
            
            DispatchQueue.main.async {
                if self.navDetailCardViewController.arahSegmentedControl.selectedSegmentIndex == 0 {
                    self.navDetailCardViewController.lblShortestTime1.text = "\(self.selPergi!)"
                    self.navDetailCardViewController.lblShortestTime2.text = "\(self.selPergi! + 15)"
                    self.navDetailCardViewController.lblShortestTime3.text = "\(self.selPergi! + 30)"
                    
                    self.navDetailCardViewController.lblStop.text = nearPergi
                    
                    stop = nearPergi
                    
                    self.navDetailCardViewController.lblTime1.text = self.waktuPergi[0]
                    self.navDetailCardViewController.lblTime2.text = self.waktuPergi[1]
                    self.navDetailCardViewController.lblTime3.text = self.waktuPergi[2]
                    self.navDetailCardViewController.lblTime4.text = self.waktuPergi[3]
                    self.navDetailCardViewController.lblTime5.text = self.waktuPergi[4]
                    self.navDetailCardViewController.lblTime6.text = self.waktuPergi[5]
                    self.navDetailCardViewController.lblTime7.text = self.waktuPergi[6]
                    self.navDetailCardViewController.lblTime8.text = self.waktuPergi[7]
                } else if self.navDetailCardViewController.arahSegmentedControl.selectedSegmentIndex == 1 {
                    self.navDetailCardViewController.lblShortestTime1.text = "\(self.selPulang!)"
                    self.navDetailCardViewController.lblShortestTime2.text = "\(self.selPulang! + 15)"
                    self.navDetailCardViewController.lblShortestTime3.text = "\(self.selPulang! + 30)"
                    
                    self.navDetailCardViewController.lblStop.text = nearPulang
                    
                    stop = nearPulang
                    
                    self.navDetailCardViewController.lblTime1.text = self.waktuPulang[0]
                    self.navDetailCardViewController.lblTime2.text = self.waktuPulang[1]
                    self.navDetailCardViewController.lblTime3.text = self.waktuPulang[2]
                    self.navDetailCardViewController.lblTime4.text = self.waktuPulang[3]
                    self.navDetailCardViewController.lblTime5.text = self.waktuPulang[4]
                    self.navDetailCardViewController.lblTime6.text = self.waktuPulang[5]
                    self.navDetailCardViewController.lblTime7.text = self.waktuPulang[6]
                    self.navDetailCardViewController.lblTime8.text = self.waktuPulang[7]
                }
            }
        }
        
        publicDatabase.perform(query, inZoneWith: nil) { (result, error) in
            resultRoute = result!
            
            if resultRoute[0]["arah"] == "pergi" {
                self.routePergi = resultRoute[0]["namaStop"]!
                self.routePulang = resultRoute[1]["namaStop"]!
            } else {
                self.routePergi = resultRoute[1]["namaStop"]!
                self.routePulang = resultRoute[0]["namaStop"]!
            }
            DispatchQueue.main.async {
                if arah == "pergi" {
                    self.navDetailCardViewController.arahSegmentedControl.selectedSegmentIndex = 0
                    self.navDetailCardViewController.kodeRute.text = "Breeze - ICE"
                    self.navDetailCardViewController.lblStop1.text = self.routePergi[0]
                    self.navDetailCardViewController.lblStop2.text = self.routePergi[1]
                    self.navDetailCardViewController.lblStop3.text = self.routePergi[2]
                    self.navDetailCardViewController.lblStop4.text = self.routePergi[3]
                    self.navDetailCardViewController.lblStop5.text = self.routePergi[4]
                    self.navDetailCardViewController.lblStop6.text = self.routePergi[5]
                    self.navDetailCardViewController.lblStop7.text = self.routePergi[6]
                    self.navDetailCardViewController.lblStop8.text = self.routePergi[7]
                } else if arah == "pulang" {
                    self.navDetailCardViewController.arahSegmentedControl.selectedSegmentIndex = 1
                    self.navDetailCardViewController.kodeRute.text = "ICE - Breeze"
                    self.navDetailCardViewController.lblStop1.text = self.routePulang[0]
                    self.navDetailCardViewController.lblStop2.text = self.routePulang[1]
                    self.navDetailCardViewController.lblStop3.text = self.routePulang[2]
                    self.navDetailCardViewController.lblStop4.text = self.routePulang[3]
                    self.navDetailCardViewController.lblStop5.text = self.routePulang[4]
                    self.navDetailCardViewController.lblStop6.text = self.routePulang[5]
                    self.navDetailCardViewController.lblStop7.text = self.routePulang[6]
                    self.navDetailCardViewController.lblStop8.text = self.routePulang[7]
                }
            }
        }
    }
    
    func naikBtnPressed(rute: String, arah: String) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.6) {
                self.commuteNaikModalViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaH - 20
                self.navDetailCardViewController.view.frame.origin.y = self.view.frame.height
                self.tabBarController?.tabBar.layer.zPosition = -1
                
                self.mapView.animate(toZoom: 16)
                
                if arah == "pergi" {
                    self.commuteNaikModalViewController.lblStop.text = self.nearPergi
                    self.commuteNaikModalViewController.lblRoute.text = "Breeze - ICE"
                    
                    self.commuteNaikModalViewController.lblStop1.text = self.routePergi[0]
                    self.commuteNaikModalViewController.lblStop2.text = self.routePergi[1]
                    self.commuteNaikModalViewController.lblStop3.text = self.routePergi[2]
                    self.commuteNaikModalViewController.lblStop4.text = self.routePergi[3]
                    self.commuteNaikModalViewController.lblStop5.text = self.routePergi[4]
                    self.commuteNaikModalViewController.lblStop6.text = self.routePergi[5]
                    self.commuteNaikModalViewController.lblStop7.text = self.routePergi[6]
                    self.commuteNaikModalViewController.lblStop8.text = self.routePergi[7]
                    
                    self.commuteNaikModalViewController.lblWaktu1.text = self.waktuPergi[0]
                    self.commuteNaikModalViewController.lblWaktu2.text = self.waktuPergi[1]
                    self.commuteNaikModalViewController.lblWaktu3.text = self.waktuPergi[2]
                    self.commuteNaikModalViewController.lblWaktu4.text = self.waktuPergi[3]
                    self.commuteNaikModalViewController.lblWaktu5.text = self.waktuPergi[4]
                    self.commuteNaikModalViewController.lblWaktu6.text = self.waktuPergi[5]
                    self.commuteNaikModalViewController.lblWaktu7.text = self.waktuPergi[6]
                    self.commuteNaikModalViewController.lblWaktu8.text = self.waktuPergi[7]
                } else {
                    self.commuteNaikModalViewController.lblStop.text = self.nearPulang
                    self.commuteNaikModalViewController.lblRoute.text = "ICE - Breeze"
                    
                    self.commuteNaikModalViewController.lblStop1.text = self.routePulang[0]
                    self.commuteNaikModalViewController.lblStop2.text = self.routePulang[1]
                    self.commuteNaikModalViewController.lblStop3.text = self.routePulang[2]
                    self.commuteNaikModalViewController.lblStop4.text = self.routePulang[3]
                    self.commuteNaikModalViewController.lblStop5.text = self.routePulang[4]
                    self.commuteNaikModalViewController.lblStop6.text = self.routePulang[5]
                    self.commuteNaikModalViewController.lblStop7.text = self.routePulang[6]
                    self.commuteNaikModalViewController.lblStop8.text = self.routePulang[7]
                    
                    self.commuteNaikModalViewController.lblWaktu1.text = self.waktuPulang[0]
                    self.commuteNaikModalViewController.lblWaktu2.text = self.waktuPulang[1]
                    self.commuteNaikModalViewController.lblWaktu3.text = self.waktuPulang[2]
                    self.commuteNaikModalViewController.lblWaktu4.text = self.waktuPulang[3]
                    self.commuteNaikModalViewController.lblWaktu5.text = self.waktuPulang[4]
                    self.commuteNaikModalViewController.lblWaktu6.text = self.waktuPulang[5]
                    self.commuteNaikModalViewController.lblWaktu7.text = self.waktuPulang[6]
                    self.commuteNaikModalViewController.lblWaktu8.text = self.waktuPulang[7]
                }
            }
        }
        
        mapView.clear()
        
        // CloudKit
        
        let routePredicate = NSPredicate(format: "arah == %@ AND kodeRute == %@", arah, rute)
        let query = CKQuery(recordType: "DataRoute", predicate: routePredicate)
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let publicDatabase = container.publicCloudDatabase
        
        publicDatabase.perform(query, inZoneWith: nil) { (result, error) in
            if result!.count > 0 {
                DispatchQueue.main.async {
                    self.mapView.clear()
                }
                
                var found = false
                let resStop = result![0]["namaStop"] as? [String]
                let resLat = result![0]["latStop"] as? [CLLocationDegrees]
                let resLong = result![0]["longStop"] as? [CLLocationDegrees]
                
                for i in 0...resStop!.count - 2 {
                    if found == false {
                        if resStop![i] == stop! {
                            print(resStop![i])
                            found = true
                            let firstLoc = CLLocationCoordinate2D(latitude: resLat![i], longitude: resLong![i])
                            let secondLoc = CLLocationCoordinate2D(latitude: resLat![i + 1], longitude: resLong![i + 1])
                            DispatchQueue.main.async {
                                let stopMarker = GMSMarker(position: firstLoc)
                                stopMarker.title  = resStop![i]
                                stopMarker.icon = UIImage(named: "halte")
                                stopMarker.map = self.mapView
                                self.drawRoute(from: firstLoc, to: secondLoc)
                            }
                        }
                    } else {
                        print(resStop![i])
                        let firstLoc = CLLocationCoordinate2D(latitude: resLat![i], longitude: resLong![i])
                        let secondLoc = CLLocationCoordinate2D(latitude: resLat![i + 1], longitude: resLong![i + 1])
                        DispatchQueue.main.async {
                            let stopMarker = GMSMarker(position: firstLoc)
                            stopMarker.title  = resStop![i]
                            stopMarker.icon = UIImage(named: "halte")
                            stopMarker.map = self.mapView
                            self.drawRoute(from: firstLoc, to: secondLoc)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    let stopMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: resLat![resStop!.count - 1], longitude: resLong![resStop!.count - 1]))
                    stopMarker.title = resStop![resStop!.count - 1]
                    stopMarker.icon = UIImage(named: "halte")
                    stopMarker.map = self.mapView
                }
            }
        }
    }
    
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
    
    func navBackPressed() {
        UIView.animate(withDuration: 0.6) {
            self.navDetailCardViewController.view.frame.origin.y = self.view.frame.height
            self.commuteModalViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight + 50
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
    
    enum CardNaikState {
        case expanded
        case collapsed
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
    
    var nextStateCommute: CardStateCommute {
        //        return cardCommuteVisible ? .collapsed : .expanded
        if cardCommuteVisible == 0 {
            return .collapsed
        } else {
            return .expanded
        }
    }
    
    var nextStateNaik:CardNaikState {
        return cardNaikVisible ? .collapsed : .expanded
    }
    
    var commuteModalViewController: CommuteModalViewController!
    var navDetailCardViewController: NavDetailCardViewController!
    var commuteNaikModalViewController: CommuteNaikModalViewController!
    var visualEffectView: UIVisualEffectView!
    let cardHeight: CGFloat = 500
    let cardHandleAreaH: CGFloat = 250
    var cardNavDetailVisible = 0
    var cardCommuteVisible = 0
    var arahCard = ""
    var handleCard = ""
    var cardNaikVisible = false
    let cardNaikHeight: CGFloat = 623
    //    let cardHandleAreaH:CGFloat = 250
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressInterrupted = 0
    
    //MAP----------------------
    var mapView: GMSMapView!
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
                // CloudKit
                
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
                            stopMarker.icon = UIImage(named: "halte")
                            stopMarker.map = self.mapView
                        }
                    }
                }
            }
            self.mainView.addSubview(mapView)
            
            setupCardNavDetail()
            setupCardCommute()
            setupCardNaik()
            
            commuteModalViewController.xibDelegate = self
            navDetailCardViewController.delegate = self
            commuteNaikModalViewController.xibDelegate = self
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
    
    
    func countDistance(firstLoc: CLLocationCoordinate2D, secondLoc: CLLocationCoordinate2D) -> Double {
        return GMSGeometryDistance(firstLoc, secondLoc)
    }
    
    func getShortestTime(rute: String, completion: @escaping (_ selisihPergi: Int, _ selisihPulang: Int, _ timesPergi: [String], _ timesPulang: [String]) -> ()) {
        // CloudKit
        
        let container = CKContainer(identifier: "iCloud.com.BussMeStoryboard")
        let publicDatabase = container.publicCloudDatabase
        let predicateStop = NSPredicate(format: "kodeRute == %@", rute)
        // let predicateStop = NSPredicate(value: true) --> untuk ambil semua isinya
        let queryStop = CKQuery(recordType: "DataScheduleList", predicate: predicateStop)
        
        var selPergi: Int = 0
        var selPulang: Int = 0
        var waktuPergi: [String] = []
        var waktuPulang: [String] = []
        
        publicDatabase.perform(queryStop, inZoneWith: nil) { (resultStops, error) in
            if error == nil {
                let currTime = self.getCurrTime()
                let arrCurrTime = currTime.components(separatedBy: ":")
                let currHour = Int(arrCurrTime[0])
                let currMinute = Int(arrCurrTime[1])
                
                //                print(currTime)
                
                var arrStopPergi: [CKRecord] = []
                var arrStopPulang: [CKRecord] = []
                
                for resultStop in resultStops! {
                    if resultStop["arah"] == "pergi" {
                        arrStopPergi.append(resultStop)
                    } else if resultStop["arah"] == "pulang" {
                        arrStopPulang.append(resultStop)
                    }
                }
                
                var minSelisih = 1000000000
                var nearestIndex = 0
                var index = 0
                for stopPergi in arrStopPergi {
                    let arrStop = stopPergi["namaStop"] as! [String]
                    let arrWaktu = stopPergi["waktu"] as! [String]
                    
                    for i in 0...arrStop.count - 1 {
                        if arrStop[i] == self.nearPergi {
                            let stopTime = arrWaktu[i]
                            let arrStopTime = stopTime.components(separatedBy: ":")
                            let stopHour = Int(arrStopTime[0])
                            let stopMinute = Int(arrStopTime[1])
                            
                            if currHour! == stopHour!{
                                if stopMinute! >= currMinute! {
                                    let selisih = stopMinute! - currMinute!
                                    if minSelisih > selisih {
                                        minSelisih = selisih
                                        nearestIndex = index
                                        //                                        print("\(nearestIndex) selisih \(minSelisih)")
                                    }
                                }
                            } else if currHour! == stopHour! - 1 {
                                let selisih = 60 - currMinute! + stopMinute!
                                if minSelisih > selisih {
                                    minSelisih = selisih
                                    nearestIndex = index
                                    //                                    print("\(nearestIndex) selisih \(minSelisih)")
                                }
                            }
                        }
                    }
                    index = index + 1
                }
                selPergi = minSelisih
                //                print(selPergi)
                waktuPergi = arrStopPergi[nearestIndex]["waktu"] as! [String]
                
                nearestIndex = 0
                minSelisih = 1000000000
                index = 0
                
                for stopPulang in arrStopPulang {
                    let arrStop = stopPulang["namaStop"] as! [String]
                    let arrWaktu = stopPulang["waktu"] as! [String]
                    
                    for i in 0...arrStop.count - 1 {
                        if arrStop[i] == self.nearPulang {
                            let stopTime = arrWaktu[i]
                            let arrStopTime = stopTime.components(separatedBy: ":")
                            let stopHour = Int(arrStopTime[0])
                            let stopMinute = Int(arrStopTime[1])
                            
                            if currHour! == stopHour!{
                                if stopMinute! > currMinute! {
                                    let selisih = stopMinute! - currMinute!
                                    if minSelisih > selisih {
                                        minSelisih = selisih
                                        nearestIndex = index
                                    }
                                }
                            } else if currHour! == stopHour! - 1 {
                                let selisih = 60 - currMinute! + stopMinute!
                                if minSelisih > selisih {
                                    minSelisih = selisih
                                    nearestIndex = index
                                }
                            }
                        }
                    }
                    index = index + 1
                }
                selPulang = minSelisih
                //                print(selPulang)
                waktuPulang = arrStopPulang[nearestIndex]["waktu"] as! [String]
                
                completion(selPergi, selPulang, waktuPergi, waktuPulang)
            } else {
                print(error as Any)
            }
        }
    }
    
    func getCurrTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        
        return "\(components.hour!):\(components.minute!)"
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
        
        commuteModalViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - self.cardHeight + 50, width: self.view.bounds.width, height: cardHeight)
        
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
    
    func startInteractiveTransitionCommute(state: CardStateCommute, duration: TimeInterval) {
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
    
    func continueInteractiveTransitionCommute(){
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
        
        navDetailCardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.bounds.width, height: 863)
        
        navDetailCardViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NavDetailViewController.handleCardNavDetailTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(NavDetailViewController.handleCardNavDetailPan(recognizer:)))
        
        navDetailCardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        navDetailCardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc
    func handleCardNavDetailTap(recognizer: UITapGestureRecognizer) {
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
    func handleCardNavDetailPan (recognizer: UIPanGestureRecognizer) {
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
                    self.navDetailCardViewController.view.frame.origin.y = self.view.frame.height - 893
                case .collapsed:
                    self.navDetailCardViewController.view.frame.origin.y = self.view.frame.height - 460
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
    
    func startInteractiveTransitionNavDetail(state: CardStateNavDetail, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeededNavDetail(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressInterrupted = Int(animator.fractionComplete)
        }
    }
    
    func updateInteractiveTransitionNavDetail(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + CGFloat(animationProgressInterrupted)
        }
    }
    
    func continueInteractiveTransitionNavDetail() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    // CARD NAIK
    func setupCardNaik() {
        commuteNaikModalViewController = CommuteNaikModalViewController(nibName: "CommuteNaikModalViewController", bundle: nil)
        self.addChild(commuteNaikModalViewController)
        self.view.addSubview(commuteNaikModalViewController.view)
        
        commuteNaikModalViewController.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.bounds.width, height: cardNaikHeight)
        
        commuteNaikModalViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommuteNaikViewController.handleCardNaikTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CommuteNaikViewController.handleCardNaikPan(recognizer:)))
        
        commuteNaikModalViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        commuteNaikModalViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    @objc
    func handleCardNaikTap(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeededNaik(state: nextStateNaik, duration: 0.65)
        default:
            break
        }
        
    }
    @objc
    func handleCardNaikPan (recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransitionNaik(state: nextStateNaik, duration: 0.35)
        case .changed:
            let translation = recognizer.translation(in: self.commuteNaikModalViewController.handleArea)
            var fractionComplete = translation.y / cardNaikHeight
            fractionComplete = cardNaikVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransitionNaik(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransitionNaik()
        default:
            break
        }
    }
    
    func animateTransitionIfNeededNaik (state:CardNaikState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 5) {
                switch state {
                case .expanded:
                    self.commuteNaikModalViewController.view.frame.origin.y = self.view.frame.height - self.cardNaikHeight
                case .collapsed:
                    self.commuteNaikModalViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaH - 20
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardNaikVisible = !self.cardNaikVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
        }
    }
    
    func startInteractiveTransitionNaik(state: CardNaikState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeededNaik(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressInterrupted = Int(animator.fractionComplete)
        }
    }
    
    func updateInteractiveTransitionNaik(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + CGFloat(animationProgressInterrupted)
        }
    }
    
    func continueInteractiveTransitionNaik (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
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
}
