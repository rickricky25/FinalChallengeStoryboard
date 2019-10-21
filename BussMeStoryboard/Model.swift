//
//  Model.swift
//  BussMeStoryboard
//
//  Created by Ricky Effendi on 18/10/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import Foundation
// MARK: - GoogleMapGeoCode
struct GoogleMapGeoCode: Codable {
//    let geocodedWaypoints: [GeocodedWaypoint]
    let routes: [Route]
    let status: String

    enum CodingKeys: String, CodingKey {
//        case geocodedWaypoints
        case routes
        case status
    }
}

// MARK: - GeocodedWaypoint
struct GeocodedWaypoint: Codable {
    let geocoderStatus, placeID: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case geocoderStatus
        case placeID
        case types
    }
}

// MARK: - Route
struct Route: Codable {
    let bounds: Bounds
    let copyrights: String
    let legs: [Leg]
    let overviewPolyline: Polyline
    let summary: String
//    let warnings, waypointOrder: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case bounds, copyrights, legs
        case overviewPolyline
        case summary
//        , warnings
//        case waypointOrder
    }
}

// MARK: - Bounds
struct Bounds: Codable {
    let northeast, southwest: Northeast
}

// MARK: - Northeast
struct Northeast: Codable {
    let lat, lng: Double
}

// MARK: - Leg
struct Leg: Codable {
    let distance, duration: Distance
    let endAddress: String?
    let endLocation: Northeast
    let startAddress: String
    let startLocation: Northeast
    let steps: [Step]
//    let trafficSpeedEntry, viaWaypoint: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case distance, duration
        case endAddress
        case endLocation
        case startAddress
        case startLocation
        case steps
//        case trafficSpeedEntry
//        case viaWaypoint
    }
}

// MARK: - Distance
struct Distance: Codable {
    let text: String
    let value: Int
}

// MARK: - Step
struct Step: Codable {
    let distance, duration: Distance
    let endLocation: Northeast
    let htmlInstructions: String
    let polyline: Polyline
    let startLocation: Northeast
    let travelMode: TravelMode
    let maneuver: String?

    enum CodingKeys: String, CodingKey {
        case distance, duration
        case endLocation
        case htmlInstructions
        case polyline
        case startLocation
        case travelMode
        case maneuver
    }
}

// MARK: - Polyline
struct Polyline: Codable {
    let points: String
}

enum TravelMode: String, Codable {
    case driving = "DRIVING"
}
