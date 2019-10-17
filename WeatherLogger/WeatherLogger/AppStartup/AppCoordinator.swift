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

    private lazy var currentWeatherRemoteResource = CurrentWeatherRemoteResource(httpClient: dependencies.httpClient)
    private lazy var navigationController = UINavigationController(rootViewController: weatherController)

    func start() {
        weatherController.delegate = self

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func fetchCurrentWeatherDataAndAppendAsNewResult() {

        currentWeatherRemoteResource.fetchCurrentWeatherData { result in
            switch result {
                case .success(let currentWeatherData):
                    DispatchQueue.main.async {
                        self.weatherController.configure(with: [currentWeatherData])
                    }
                case .failure(let requestExecutionError):
                    print(requestExecutionError) // todo: show in UI
            }
        }
    }
}

extension AppCoordinator: CurrentWeatherViewControllerDelegate {
    func currentWeatherViewControllerDidTapSaveButton(_ controller: CurrentWeatherViewController) {
        fetchCurrentWeatherDataAndAppendAsNewResult()
    }
}
