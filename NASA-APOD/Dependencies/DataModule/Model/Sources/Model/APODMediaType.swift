//
//  MediaType.swift
//  Model
//
//  Created by Manik on 08/10/2025.
//

import Foundation

public enum APODMediaType: String, Codable, Sendable {
    case image
    case video
    case other

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = (try? container.decode(String.self)) ?? ""
        self = APODMediaType(rawValue: raw) ?? .other
    }
}
