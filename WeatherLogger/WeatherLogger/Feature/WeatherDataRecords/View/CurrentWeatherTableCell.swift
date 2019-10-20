//
//  CurrentWeatherTableCell.swift
//  WeatherLogger
//
//  Created by Radim Langer on 20/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

final class CurrentWeatherTableCell: UITableViewCell {

    private let temperatureLabel = UILabel(
        textAlignment: .center,
        font: .systemFont(ofSize: 22, weight: .bold),
        numberOfLines: 0
    )
    private let cityLabel = UILabel(
        textAlignment: .center,
        font: .systemFont(ofSize: 14, weight: .regular),
        numberOfLines: 0
    )
    private let descriptionLabel = UILabel(
        textAlignment: .center,
        font: .systemFont(ofSize: 12, weight: .regular),
        numberOfLines: 0
    )
    private let dateLabel = UILabel(
        textAlignment: .center,
        font: .systemFont(ofSize: 12, weight: .light),
        numberOfLines: 0
    )
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessibilityIdentifier = AccessibilityIdentifier.currentWeatherCell.rawValue
        [
            cityLabel,
            descriptionLabel,
            dateLabel
        ].forEach(verticalStackView.addArrangedSubview)

        contentView.addAutoLayoutSubviews(verticalStackView, temperatureLabel)
        setNeedsUpdateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        super.updateConstraints()

        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: contentView.readableContentGuide.topAnchor),

            temperatureLabel.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 8),
            temperatureLabel.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.readableContentGuide.bottomAnchor)
        ])
    }

    func configure(temperature: String, city: String, date: String, description: String) {
        temperatureLabel.text = temperature
        descriptionLabel.text = description
        cityLabel.text = city
        dateLabel.text = date
    }
}
