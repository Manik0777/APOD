//
//  DashboardViewModel.swift
//  Dashboard
//
//  Created by Manik on 07/10/2025.
//

import Foundation
import Model
import Repository
import CoreUtils

@MainActor
public final class DashboardViewModel: ObservableObject {
    private let repository: any APODRepository

    @Published public var apod: APOD?
    @Published public var isLoading: Bool = false
    @Published public var isFallback: Bool = false

    public init(repository: any APODRepository) {
        self.repository = repository
    }

    public func loadToday() async {
        isLoading = true
        defer { isLoading = false }

        let result = await repository.getAPOD(for: nil)
        self.apod = result

        // Detect fallback if today's APOD wasn't returned
        if let returnedDate = result?.date,
           APODDateFormatter.shared.string(from: Date()) != returnedDate {
            self.isFallback = true
           // print("Fallback triggered — Expected: \(APODDateFormatter.shared.string(from: Date())), Returned: \(returnedDate)")
        } else {
            self.isFallback = false
        }
    }
}
