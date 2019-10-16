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

    private lazy var navigationController = UINavigationController(rootViewController: UIViewController())

    func start() {

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
