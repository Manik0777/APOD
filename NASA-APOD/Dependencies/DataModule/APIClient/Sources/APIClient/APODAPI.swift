//
//  APODAPI.swift
//  APIClient
//
//  Created by Manik on 07/10/2025.
//

import Foundation
import Model

public final class APODAPI: @unchecked Sendable {
    private let apiKey: String
    private let base = URL(string: "https://api.nasa.gov/planetary/apod")!

    public init(apiKey: String? = nil) {
        self.apiKey = apiKey ?? ProcessInfo.processInfo.environment["NASA_API_KEY"] ?? "DEMO_KEY"
    }
    
    public func fetchAPOD(for date: Date?) async throws -> APOD {
        var components = URLComponents(url: base, resolvingAgainstBaseURL: false)!
        var items = [URLQueryItem(name: "api_key", value: apiKey)]
        if let date = date {
            let df = DateFormatter(); df.dateFormat = "yyyy-MM-dd"
            items.append(URLQueryItem(name: "date", value: df.string(from: date)))
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
