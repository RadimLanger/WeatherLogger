//
//  CurrentWeatherTableDataSource.swift
//  WeatherLogger
//
//  Created by Radim Langer on 17/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

final class CurrentWeatherTableDataSource: NSObject, UITableViewDataSource {

    // MARK: - Definition of section, items and configurator

    enum CurrentWeatherItem {
        case weather(CurrentWeatherData)
    }

    struct TableViewSection {
        var items: [CurrentWeatherItem]
    }

    struct CollectionCellDescriptor {

        public let cellClass: UITableViewCell.Type
        public let configure: ((UITableViewCell) -> Void)?

        public init<Cell: UITableViewCell>(cellClass: Cell.Type, configure: ((Cell) -> Void)? = nil) {

            self.cellClass = cellClass

            if let configure = configure {
                self.configure = { cell in (cell as? Cell).map(configure) }
            } else {
                self.configure = nil
            }
        }
    }

    // MARK: - Setting data

    var sections = [TableViewSection]()

    var weatherData: [CurrentWeatherData] = [] {
        didSet {
            configure()
        }
    }

    private func configure() {
        sections = [.init(items: weatherData.map(CurrentWeatherItem.weather))]
    }

    private func cellDescriptor(for item: CurrentWeatherItem) -> CollectionCellDescriptor {
        switch item {
            case .weather(let currentWeatherData): return currentWeatherDataCellDescriptor(for: currentWeatherData)
        }
    }

    private func currentWeatherDataCellDescriptor(
        for currentWeatherData: CurrentWeatherData
    ) -> CollectionCellDescriptor {
        return .init(cellClass: UITableViewCell.self) { cell in
            cell.textLabel?.text = String(describing: currentWeatherData.list.first?.main.temp)
        }
    }

    // MARK: - Setting TableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = sections[indexPath.section].items[indexPath.row]
        let descriptor = cellDescriptor(for: item)
        let reuseIdentifier = String(describing: descriptor.cellClass)
        tableView.register(descriptor.cellClass, forCellReuseIdentifier: reuseIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        descriptor.configure?(cell)

        return cell
    }
}
