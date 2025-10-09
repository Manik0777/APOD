//
//  ErrorViewRepresentable.swift
//  CoreUI
//
//  Created by Manik on 08/10/2025.
//

import SwiftUI

public struct ErrorViewRepresentable: UIViewRepresentable {
    public let message: String
    public let onRetry: (() -> Void)?

    public init(message: String, onRetry: (() -> Void)? = nil) {
        self.message = message
        self.onRetry = onRetry
    }

    public func makeUIView(context: Context) -> ErrorView {
        ErrorView(message: message, onRetry: onRetry)
    }

    public func updateUIView(_ uiView: ErrorView, context: Context) { }
}
