//
//  APODDateFormatter.swift
//  CoreUtils
//
//  Created by Manik on 09/10/2025.
//

import Foundation

public enum APODDateFormatter {
    public static let shared: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // NASA uses UTC
        return formatter
    }()
}

public enum APODISOFormatter {
    @MainActor public static let shared: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}

public enum APODDisplayFormatter {
    public static let shared: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeZone = TimeZone.current
        return formatter
    }()
}
