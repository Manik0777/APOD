//
//  ErrorBannerModifier.swift
//  CoreUI
//
//  Created by Manik on 09/10/2025.
//

import SwiftUI

struct ErrorBannerModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let retryAction: (() -> Void)?

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                VStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Text(message)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        if let retryAction = retryAction {
                            Button("Retry", action: retryAction)
                                .foregroundColor(.white)
                                .bold()
                        }
                    }
                    .padding()
                    .background(Color.red.opacity(0.9))
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .animation(.easeInOut, value: isPresented)
            }
        }
    }
}

extension View {
    public func errorBanner(
        isPresented: Binding<Bool>,
        message: String,
        retryAction: (() -> Void)? = nil
    ) -> some View {
        self.modifier(ErrorBannerModifier(
            isPresented: isPresented,
            message: message,
            retryAction: retryAction
        ))
    }
}
