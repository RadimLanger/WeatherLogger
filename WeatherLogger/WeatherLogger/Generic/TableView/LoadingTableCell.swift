//
//  LoadingTableCell.swift
//  WeatherLogger
//
//  Created by Radim Langer on 20/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

import UIKit

final class LoadingTableCell: UITableViewCell {

    let loadingIndicator = UIActivityIndicatorView(style: .white)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addAutoLayoutSubviews(loadingIndicator)

        isUserInteractionEnabled = false
        setNeedsUpdateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func updateConstraints() {
        super.updateConstraints()

        NSLayoutConstraint.activate([
            loadingIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            loadingIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 44),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 44)
        ])
    }

    static func descriptor(color: UIColor? = nil) -> TableCellDescriptor {
        return .init(cellClass: LoadingTableCell.self) { cell in
            cell.loadingIndicator.startAnimating()
            cell.loadingIndicator.color = color
        }
    }
}
