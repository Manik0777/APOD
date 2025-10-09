//
//  APODAPI.swift
//  APIClient
//
//  Created by Manik on 07/10/2025.
//

import Foundation
import Model
import CoreUtils

enum APODConstants {
    static let apiBaseURL = "https://api.nasa.gov/planetary"
    static let apodEndpoint = "\(apiBaseURL)/apod"
    static let defaultApiKey = "DEMO_KEY" // Replace with secure key management in production
    static let prodApiKey = "NASA_API_KEY"
    
    enum Keys {
        static let apiKey = "api_key"
        static let date = "date"
    }
}

public protocol APODAPIProtocol: Sendable {
    func fetchAPOD(for date: Date?) async throws -> APOD
    func fetchImageData(for url: URL) async throws -> Data?
}

//public final class APODAPI:  @unchecked Sendable {
public final class APODAPI: APODAPIProtocol {
    private let apiKey: String
//    private let base = URL(string: "https://api.nasa.gov/planetary/apod")!
    private let base = URL(string: APODConstants.apodEndpoint)!
    
    public init(apiKey: String? = nil) {
        self.apiKey = apiKey ?? ProcessInfo.processInfo.environment[APODConstants.prodApiKey] ?? APODConstants.defaultApiKey
    }
    
    public func fetchAPOD(for date: Date?) async throws -> APOD {
        var components = URLComponents(url: base, resolvingAgainstBaseURL: false)!
        var items = [URLQueryItem(name: APODConstants.Keys.apiKey, value: apiKey)]
        if let date = date {
            let df = DateFormatter(); df.dateFormat = "yyyy-MM-dd"
            items.append(URLQueryItem(name: APODConstants.Keys.date, value: df.string(from: date)))
        }
        components.queryItems = items
        guard let url = components.url else { throw URLError(.badURL) }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            //print("❌ API error: \(response)")
            throw URLError(.badServerResponse)
        }

        let apod = try JSONDecoder().decode(APOD.self, from: data)
        //print("✅ APOD fetched:", apod.title)
        return apod
    }


    // New helper to fetch image bytes; returns nil if status invalid
    public func fetchImageData(for url: URL) async throws -> Data? {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
