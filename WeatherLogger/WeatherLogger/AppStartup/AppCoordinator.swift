//
//  AppCoordinator.swift
//  WeatherLogger
//
//  Created by Radim Langer on 16/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {

    private let window = UIWindow(frame: UIScreen.main.bounds)
    private let dependencies = Dependencies()
    private let weatherController = CurrentWeatherViewController()
    private let weatherCache = CodableCache<[CurrentWeatherData]>()

    private var didTriggerCurrentWeatherDataLoading = false

    private lazy var currentWeatherRemoteResource = CurrentWeatherRemoteResource(httpClient: dependencies.httpClient)
    private lazy var navigationController = UINavigationController(rootViewController: weatherController)

    func start() {
        weatherController.delegate = self
        dependencies.locationProvider.delegate = self

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        weatherController.configureAndReloadUI(with: weatherCache.data ?? [])
    }

    private func fetchCurrentWeatherData(searchParameter: CurrentWeatherQuery.SearchParameter ) { // todo:
        DispatchQueue.main.async {
            self.weatherController.updateLoading(to: true)
        }

        currentWeatherRemoteResource.fetchCurrentWeatherData(for: .init(searchParameter: searchParameter)) { result in
            self.didTriggerCurrentWeatherDataLoading = false
            switch result {
                case .success(let currentWeatherData):
                    self.storeNewWeatherDataAndShowInUI(data: currentWeatherData)
                case .failure(let requestExecutionError):
                    debugPrint(requestExecutionError) // todo: show in UI
            }
        }
    }

    private func askForLocationPermitionsIfNotEnabled() {
        if dependencies.locationProvider.isLocationServiceEnabled == false {
            dependencies.locationProvider.requestWhenInUseAuthorization()
        }
    }

    private func storeNewWeatherDataAndShowInUI(data: CurrentWeatherData) {
        let newDataToStore = [data] + (weatherCache.data ?? [])
        weatherCache.data = newDataToStore
        DispatchQueue.main.async {
            self.weatherController.configureAndReloadUI(with: newDataToStore)
            self.weatherController.updateLoading(to: false)
        }
    }
}

extension AppCoordinator: CurrentWeatherViewControllerDelegate {
    func currentWeatherViewControllerDidTapSaveButton(_ controller: CurrentWeatherViewController) {

        didTriggerCurrentWeatherDataLoading = true

        if dependencies.locationProvider.isLocationServiceDeniedByUser {
            fetchCurrentWeatherData(searchParameter: .city(name: "Riga", state: "LV"))
        } else if dependencies.locationProvider.isLocationServiceEnabled {
            dependencies.locationProvider.startUpdatingLocation()
        } else {
            askForLocationPermitionsIfNotEnabled()
        }
    }
}

extension AppCoordinator: LocationProviderDelegate {
    func locationProvider(
        _ provider: LocationProvider,
        didUpdate locationCoordinate: LocationProvider.LocationCoordinate
    ) {
        guard didTriggerCurrentWeatherDataLoading else { return }

        fetchCurrentWeatherData(
            searchParameter: .geographicCoordinates(
                latitude: locationCoordinate.latitude,
                longitude: locationCoordinate.longitude
            )
        )
    }

    func locationProvider(_ provider: LocationProvider, didFailUpdatingWith error: Error) {
        fetchCurrentWeatherData(searchParameter: .city(name: "Riga", state: "LV"))
    }
}
