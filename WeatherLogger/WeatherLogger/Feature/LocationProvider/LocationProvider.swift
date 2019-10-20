//
//  LocationProvider.swift
//  WeatherLogger
//
//  Created by Radim Langer on 18/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

import CoreLocation
import UIKit
import Foundation

protocol LocationProviderDelegate: AnyObject {
    func locationProvider(
        _ provider: LocationProvider,
        didUpdate locationCoordinate: LocationProvider.LocationCoordinate
    )
    func locationProvider(_ provider: LocationProvider, didFailUpdatingWith error: Error)
}

final class LocationProvider: NSObject {

    struct LocationCoordinate: Codable {
        let latitude: Double
        let longitude: Double
    }

    weak var delegate: LocationProviderDelegate?

    private let clLocationManager = CLLocationManager()
    private let lastKnownLocation = CodableCache<LocationCoordinate>()

    var isLocationServiceEnabled: Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }

    var isLocationServiceDeniedByUser: Bool { CLLocationManager.authorizationStatus() == .denied }

    override init() {
        super.init()
        clLocationManager.delegate = self
    }

    func startUpdatingLocation() {
        clLocationManager.startUpdatingLocation()
    }

    func requestWhenInUseAuthorization() {
        clLocationManager.requestWhenInUseAuthorization()
    }
}

extension LocationProvider: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if isLocationServiceEnabled {
            clLocationManager.startUpdatingLocation()
        } else {
            lastKnownLocation.data = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        debugPrint("⚠️ Error CLLocationManager updating location: \(error)")
        delegate?.locationProvider(self, didFailUpdatingWith: error)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        manager.stopUpdatingLocation()
        let coordinate = lastLocation.coordinate
        let newLocationCoordinate = LocationCoordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
        lastKnownLocation.data = newLocationCoordinate
        delegate?.locationProvider(self, didUpdate: newLocationCoordinate)
    }
}
