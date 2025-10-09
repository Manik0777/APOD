//
//  APOD.swift
//  Model
//
//  Created by Manik on 07/10/2025.
//

/*
import Foundation

public struct APOD: Codable, Sendable {
    public let date: String
    public let title: String
    public let explanation: String
    public let mediaType: String
    public let url: URL?
    public let hdurl: URL?
    public let copyright: String?

    public init(date: String,
                title: String,
                explanation: String,
                mediaType: String,
                url: URL?,
                hdurl: URL?,
                copyright: String?) {
        self.date = date
        self.title = title
        self.explanation = explanation
        self.mediaType = mediaType
        self.url = url
        self.hdurl = hdurl
        self.copyright = copyright
    }

    enum CodingKeys: String, CodingKey {
        case date, title, explanation
        case mediaType = "media_type"
        case url, hdurl, copyright
    }
}
*/
import Foundation

public struct APOD: Codable, Sendable {
    public let date: String
    public let title: String
    public let explanation: String
    public let mediaType: APODMediaType
    public let url: URL?
    public let hdurl: URL?
    public let copyright: String?

    public init(date: String,
                title: String,
                explanation: String,
                mediaType: APODMediaType,
                url: URL?,
                hdurl: URL?,
                copyright: String?) {
        self.date = date
        self.title = title
        self.explanation = explanation
        self.mediaType = mediaType
        self.url = url
        self.hdurl = hdurl
        self.copyright = copyright
    }

    enum CodingKeys: String, CodingKey {
        case date, title, explanation
        case mediaType = "media_type"
        case url, hdurl, copyright
    }
}
