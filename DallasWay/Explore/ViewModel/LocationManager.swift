//
//  LocationManager.swift
//  DallasWay
//
//  Created by Dharamvir Yadav on 12/19/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var userLocationHandler: ((CLLocation) -> Void)?
    var locationErrorHandler: ((String) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocationHandler?(location)
            locationManager.stopUpdatingLocation() // Stop updating to save battery
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationErrorHandler?(error.localizedDescription)
    }
}
