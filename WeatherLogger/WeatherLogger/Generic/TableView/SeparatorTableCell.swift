//
//  SeparatorTableCell.swift
//  WeatherLogger
//
//  Created by Radim Langer on 20/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

import UIKit

final class SeparatorTableCell: UITableViewCell {

    var insets: UIEdgeInsets = .zero
    var height: CGFloat = 1

    var color: UIColor {
        get {
            return UIColor(named: "SeparatorColor") ?? .gray
        }
        set {
            separatorView.backgroundColor = newValue
        }
    }

    private let separatorView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addAutoLayoutSubviews(separatorView)

        isUserInteractionEnabled = false
        setNeedsUpdateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func updateConstraints() {
        super.updateConstraints()

        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insets.top),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insets.bottom),
            separatorView.heightAnchor.constraint(equalToConstant: height),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: insets.left),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -insets.right)
        ])
    }

    static func descriptor(
        withInsets insets: UIEdgeInsets = .zero,
        height: CGFloat = 1 / UIScreen.main.scale,
        color: UIColor? = nil
    ) -> TableCellDescriptor {

        return TableCellDescriptor(cellClass: SeparatorTableCell.self) { cell in
            cell.insets = insets
            cell.height = height
            cell.color = UIColor(named: "SeparatorColor") ?? .gray
        }
    }
}
