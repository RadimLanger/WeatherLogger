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
    private var weatherController = CurrentWeatherViewController()
    private let weatherCache = CodableCache<[CurrentWeatherData]>()

    private var didTriggerCurrentWeatherDataLoading = false

    private lazy var currentWeatherRemoteResource = CurrentWeatherRemoteResource(httpClient: dependencies.httpClient)
    private lazy var navigationController = UINavigationController(rootViewController: weatherController)

    func start() {

        if ProcessInfo.processInfo.arguments.contains("--ResetForUITesting") {
            weatherCache.data = []
        }   

        weatherController.delegate = self
        dependencies.locationProvider.delegate = self

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        weatherController.configureAndReloadUI(with: weatherCache.data ?? [])
    }

    private func fetchCurrentWeatherData(searchParameter: CurrentWeatherQuery.SearchParameter ) {
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
        var data = data
        data.recievedTimeStamp = Date()
        let newDataToStore = [data] + (weatherCache.data ?? [])
        weatherCache.data = newDataToStore
        DispatchQueue.main.async {
            self.weatherController.configureAndReloadUI(with: newDataToStore)
            self.weatherController.updateLoading(to: false)
        }
    }

    private func showDetail(of data: CurrentWeatherData) {
        let controller = WeatherDetaiViewController(weatherData: data)
        controller.delegate = self
        navigationController.pushViewController(controller, animated: true)
    }
}

extension AppCoordinator: CurrentWeatherViewControllerDelegate {

    func currentWeatherViewController(
        _ controller: CurrentWeatherViewController,
        didSelect weatherData: CurrentWeatherData
    ) {
        showDetail(of: weatherData)
    }

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

extension AppCoordinator: WeatherDetaiViewControllerDelegate {

    func weatherDetaiViewControllerDidTapDeleteButton(
        _ controller: WeatherDetaiViewController,
        with data: CurrentWeatherData
    ) {
        navigationController.popViewController(animated: true)
        weatherCache.data?.removeAll(where: { $0 == data })
        weatherController.configureAndReloadUI(with: weatherCache.data ?? [])
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
