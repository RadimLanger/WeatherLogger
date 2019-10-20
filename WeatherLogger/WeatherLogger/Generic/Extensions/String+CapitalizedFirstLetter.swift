//
//  String+CapitalizedFirstLetter.swift
//  WeatherLogger
//
//  Created by Radim Langer on 20/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

import Foundation

extension String {
    func withCapitalizedFirstLetter() -> String {
      return prefix(1).uppercased() + lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.withCapitalizedFirstLetter()
    }
}
