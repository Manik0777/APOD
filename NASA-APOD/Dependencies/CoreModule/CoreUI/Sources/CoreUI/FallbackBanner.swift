//
//  FallbackBanner.swift
//  CoreUI
//
//  Created by Manik on 09/10/2025.
//

import SwiftUI

public struct FallbackBanner: View {
    public var message: String
    public var backgroundColor: Color = .orange
    public var alignment: Alignment = .top // Can be .bottom for toast

    public init(message: String, backgroundColor: Color = .orange, alignment: Alignment = .top) {
        self.message = message
        self.backgroundColor = backgroundColor
        self.alignment = alignment
    }

    public var body: some View {
        VStack {
            if alignment == .top { banner }
            Spacer()
            if alignment == .bottom { banner }
        }
        .transition(.move(edge: alignment == .top ? .top : .bottom).combined(with: .opacity))
    }

    private var banner: some View {
        Text(message)
            .font(.callout)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
    }
}
