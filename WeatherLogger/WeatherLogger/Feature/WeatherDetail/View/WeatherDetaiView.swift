//
//  WeatherDetaiView.swift
//  WeatherLogger
//
//  Created by Radim Langer on 20/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

import UIKit

final class WeatherDetaiView: UIView {

    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete record", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor(named: "Red"), for: .normal)
        button.setTitleColor(UIColor(named: "RedSelected"), for: .highlighted)
        button.accessibilityIdentifier = AccessibilityIdentifier.weatherDetaiViewDeleteButton.rawValue
        return button
    }()

    private let titleLabel = UILabel(
        textAlignment: .center,
        font: UIFont.systemFont(ofSize: 16, weight: .bold),
        numberOfLines: 0
    )

    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        addAutoLayoutSubviews(deleteButton)
//        [
//            dateLabel
//        ].forEach(verticalStackView.addArrangedSubview)

        addAutoLayoutSubviews(verticalStackView, deleteButton)
        setNeedsUpdateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        super.updateConstraints()

        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
