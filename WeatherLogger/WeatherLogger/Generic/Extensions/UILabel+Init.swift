//
//  UILabel+Init.swift
//  WeatherLogger
//
//  Created by Radim Langer on 20/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

import UIKit

extension UILabel {

    convenience init(
        textColor: UIColor? = nil,
        textAlignment: NSTextAlignment = .left,
        font: UIFont? = nil,
        numberOfLines: Int = 1
    ) {
        self.init()

        if let font = font {
            self.font = font
        }

        if let textColor = textColor {
            self.textColor = textColor
        }

        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}
