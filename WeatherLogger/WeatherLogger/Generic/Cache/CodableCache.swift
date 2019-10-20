//
//  CodableCache.swift
//  WeatherLogger
//
//  Created by Radim Langer on 18/10/2019.
//  Copyright © 2019 Accenture. All rights reserved.
//

import Foundation

public final class CodableCache<Resource: Codable> {

    private let url: URL

    public var data: Resource? {
        get {
            return decodeResource(from: url)
        }

        set {
            if let newValue = newValue {
                encodeResource(newValue, to: url)
            } else {
                try? Data().write(to: url)
            }
        }
    }

    public init(filename: String = String(describing: Resource.self) + "_codable_archive") {

        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""

        self.url = URL(fileURLWithPath: documentsPath + "/" + filename)
    }

    private func decodeResource(from url: URL) -> Resource? {

        guard let archivedData = FileManager.default.contents(atPath: url.path) else { return nil }

        return try? PropertyListDecoder().decode(Resource.self, from: archivedData)
    }

    private func encodeResource(_ resource: Resource, to url: URL) {

        let archivedData = try? PropertyListEncoder().encode(resource)
        try? archivedData?.write(to: url)
    }
}
