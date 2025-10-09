//
//  StringResources.swift
//  CoreUtils
//
//  Created by Manik on 09/10/2025.
//

import Foundation

public extension String {
    
    func localized(bundle: Bundle? = nil) -> String {
        guard let bundleValue = bundle else {
            return String(localized: LocalizationValue(self), table: nil, bundle: Bundle.main)
        }
        return String(localized: LocalizationValue(self), table: nil, bundle: bundleValue)
    }
}
