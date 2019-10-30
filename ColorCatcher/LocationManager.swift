//
//  LocationManager.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 29/10/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation


class LocationManager: NSObject, CLLocationManagerDelegate  {

    static var shared = LocationManager()
    private var manager: CLLocationManager = CLLocationManager()
    public var exposedLocation: CLLocation? {
        return self.manager.location
    }
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func getCurrentPlace(_ completion: @escaping (String?) ->()) {
        guard let exposedLocation = exposedLocation else {
            completion(nil)
            return
        }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(exposedLocation) { placemarks, error in
            guard error == nil else {
                Logger(error!)
                completion(nil)
                return
            }
            guard let placemark = placemarks?[0] else {
                Logger("placemark is nil")
                completion(nil)
                return
            }
            completion("\(placemark.locality ?? ""), \(placemark.country ?? "")")
        }
    }
}
