//
//  WeatherDetaiViewController.swift
//  WeatherLogger
//
//  Created by Radim Langer on 20/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

import UIKit

protocol WeatherDetaiViewControllerDelegate: AnyObject {
    func weatherDetaiViewControllerDidTapDeleteButton(
        _ controller: WeatherDetaiViewController,
        with data: CurrentWeatherData
    )
}

final class WeatherDetaiViewController: UIViewController {

    weak var delegate: WeatherDetaiViewControllerDelegate?

    private let weatherData: CurrentWeatherData
    private let rootView = WeatherDetaiView()

    init(weatherData: CurrentWeatherData) {
        self.weatherData = weatherData
        super.init(nibName: nil, bundle: nil)

        title = NSLocalizedString("Weather detail", comment: "")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }

    @objc private func deleteButtonTapped() {
        delegate?.weatherDetaiViewControllerDidTapDeleteButton(self, with: weatherData)
    }
}
