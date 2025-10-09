//
//  DIContainer.swift
//  NASA-APOD
//
//  Created by Manik on 07/10/2025.
//

import Foundation
import Repository
import APIClient
import CoreUtils

public final class APODDIContainer {
    public let api: APODAPI
    public let repository: any APODRepository
    public let coreDataStack: CoreDataStack

    public init(apiKey: String? = nil) {
        self.api = APODAPI(apiKey: apiKey)
        self.coreDataStack = CoreDataStack(modelName: "NASA_APOD")
        let repo = DefaultAPODRepository(api: api, coreDataStack: coreDataStack)
        self.repository = repo
    }
}
