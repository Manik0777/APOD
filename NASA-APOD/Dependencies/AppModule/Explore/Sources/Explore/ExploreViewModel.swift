//
//  ExploreViewModel.swift
//  Explore
//
//  Created by Manik on 07/10/2025.
//

import Foundation
import Model
import Repository
import CoreUtils

@MainActor
public final class ExploreViewModel: ObservableObject {
    @Published public var apod: APOD?
    @Published public var selectedDate: Date = Date()
    @Published public var isFallback: Bool = false
    @Published public var isLoading: Bool = false

    private let repository: APODRepository

    public init(repository: APODRepository) {
        self.repository = repository
    }

    public func load(date: Date?) async {
        isLoading = true
        defer { isLoading = false }

        let result = await repository.getAPOD(for: date)
        self.apod = result

        // Only mark as fallback if a date was requested AND the returned APOD doesn't match it
        if let requestedDate = date,
           let returnedDate = result?.date,
           APODDateFormatter.shared.string(from: requestedDate) != returnedDate {
            self.isFallback = true
          //  print("Fallback triggered — Requested: \(APODDateFormatter.shared.string(from: requestedDate)), Returned: \(returnedDate)")
        } else {
            self.isFallback = false
        }
    }
}
