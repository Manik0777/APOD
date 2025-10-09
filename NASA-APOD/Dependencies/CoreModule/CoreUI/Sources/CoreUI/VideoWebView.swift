//
//  VideoWebView.swift
//  CoreUI
//
//  Created by Manik on 07/10/2025.
//

import SwiftUI
import WebKit

public struct VideoWebView: UIViewRepresentable {
    public let url: URL
    public init(url: URL) { self.url = url }
    public func makeUIView(context: Context) -> WKWebView { WKWebView() }
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}
