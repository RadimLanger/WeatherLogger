//
//  CurrentWeatherViewController.swift
//  WeatherLogger
//
//  Created by Radim Langer on 17/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

import UIKit

protocol CurrentWeatherViewControllerDelegate: AnyObject {
    func currentWeatherViewControllerDidTapSaveButton(_ controller: CurrentWeatherViewController)
    func currentWeatherViewController(
        _ controller: CurrentWeatherViewController,
        didSelect weatherData: CurrentWeatherData
    )
}

final class CurrentWeatherViewController: UIViewController {

    weak var delegate: CurrentWeatherViewControllerDelegate?

    private let rootView = CurrentWeatherView()
    private let tableViewDataSource = CurrentWeatherTableDataSource()
    private var tableView: UITableView { rootView.tableView }

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Weather records", comment: "") 

        rootView.tableView.dataSource = tableViewDataSource
        rootView.tableView.delegate = self

        rootView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    @objc private func saveButtonTapped() {
        delegate?.currentWeatherViewControllerDidTapSaveButton(self)
    }

    func configureAndReloadUI(with weatherData: [CurrentWeatherData]) {
        tableViewDataSource.weatherData = weatherData
        rootView.tableView.reloadData()
    }

    func updateLoading(to isLoading: Bool) {
        tableViewDataSource.isLoading = isLoading
        rootView.tableView.reloadData()
    }
}

extension CurrentWeatherViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        guard case .weather(let weatherData) = tableViewDataSource.item(at: indexPath) else { return }
        delegate?.currentWeatherViewController(self, didSelect: weatherData)
    }
}
