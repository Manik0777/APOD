//
//  MockAPODRepository.swift
//  Explore
//
//  Created by Manik on 09/10/2025.
//

import Foundation
import Model

public final class MockAPODRepository: APODRepository {
    let apodToReturn: APOD?

    init(apodToReturn: APOD?) {
        self.apodToReturn = apodToReturn
    }

    public func getAPOD(for date: Date?) async -> APOD? {
        return apodToReturn
    }

    public func getImageData(for url: URL) async -> Data? {
        return nil
    }
}
