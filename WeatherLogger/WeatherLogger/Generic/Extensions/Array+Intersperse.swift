//
//  Array+Intersperse.swift
//  WeatherLogger
//
//  Created by Radim Langer on 20/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

extension Array {

    mutating func intersperse(_ element: Element) {

        guard count >= 2 else { return }

        for index in stride(from: count - 1, to: 0, by: -1) {
            insert(element, at: index)
        }
    }

    public func interspersed(with element: Element) -> Array {
        var newArray = self
        newArray.intersperse(element)
        return newArray
    }

}
