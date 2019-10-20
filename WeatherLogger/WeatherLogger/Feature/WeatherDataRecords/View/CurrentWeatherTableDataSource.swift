//
//  CurrentWeatherTableDataSource.swift
//  WeatherLogger
//
//  Created by Radim Langer on 17/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

enum CurrentWeatherDataSourceItem: Equatable {
    case weather(CurrentWeatherData)
    case separator
    case loadingIndicator
}

final class CurrentWeatherTableDataSource: TableDataSource<CurrentWeatherDataSourceItem> {

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "GMT")!
        return formatter
    }()

    var weatherData: [CurrentWeatherData] = [] {
        didSet {
            configure()
        }
    }

    var isLoading = false {
        didSet {
            sections[0].items.removeAll(where: { $0 == .loadingIndicator })
            guard isLoading else { return }
            sections[0].items = [.loadingIndicator] + sections[0].items
        }
    }

    override init() {
        super.init()
        sections = [Section(items: [])]
    }

    private func configure() {

        let weatherItems = weatherData.map(CurrentWeatherDataSourceItem.weather)
        let weatherItemsWithSeparators = weatherItems.interspersed(with: .separator)
        sections = [.init(items: weatherItemsWithSeparators)]
    }

    override func cellDescriptor(for item: CurrentWeatherDataSourceItem) -> TableCellDescriptor {
        switch item {
            case .weather(let currentWeatherData):  return currentWeatherDataCellDescriptor(for: currentWeatherData)
            case .separator:                        return separatorDecriptor
            case .loadingIndicator:                 return loadingIndicatorDescriptor
        }
    }

    private func currentWeatherDataCellDescriptor(
        for currentWeatherData: CurrentWeatherData
    ) -> TableCellDescriptor {
        return .init(cellClass: CurrentWeatherTableCell.self) { cell in

            let loggedTimeStamp = currentWeatherData.dt + currentWeatherData.timezone
            let dateString = self.dateFormatter.string(from: .init(timeIntervalSince1970: .init(loggedTimeStamp)))

            cell.configure(
                temperature: "\(currentWeatherData.main.temp) °C",
                city: currentWeatherData.name,
                date: dateString,
                description: (currentWeatherData.weather.first?.description ?? "").withCapitalizedFirstLetter()
            )
        }
    }

    private let separatorDecriptor = SeparatorTableCell.descriptor(
        withInsets: .init(top: 0, left: 8, bottom: 0, right: 8)
    )

    private let loadingIndicatorDescriptor = LoadingTableCell.descriptor(color: .orange)
}
