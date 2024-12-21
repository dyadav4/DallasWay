//
//  CLLocationCoordinate2D+Extensions.swift
//  DallasWay
//
//  Created by Dharamvir Yadav on 12/19/24.
//

import MapKit

extension CLLocationCoordinate2D {
    /// Converts CLLocationCoordinate2D to CLLocation
    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
}
