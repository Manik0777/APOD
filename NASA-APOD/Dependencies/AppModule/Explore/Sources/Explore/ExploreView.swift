//
//  ExploreView.swift
//  Explore
//
//  Created by Manik on 07/10/2025.
//

import SwiftUI
import Model
import CoreUI

public struct ExploreView: View {
    @ObservedObject public var viewModel: ExploreViewModel
    @State private var showError: Bool = false
    @State private var errorMessage: String?
    @State private var showFallbackBanner: Bool = false

    public init(viewModel: ExploreViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if showFallbackBanner {
                    FallbackBanner(message: "explore.screen.fallback.banner.message".localized(bundle: Bundle.module))
                }

                Group {
                    if viewModel.isLoading {
                        ProgressView("explore.screen.progressive.view.message".localized(bundle: Bundle.module))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if showError, let message = errorMessage {
                        ErrorViewRepresentable(message: message) {
                            Task { await reload() }
                        }
                    } else {
                        Form {
                            dateSelectionSection
                            contentSection
                        }
                    }
                }
            }
            .navigationTitle("explore.screen.navigation.title".localized(bundle: Bundle.module))
            .errorBanner(
                isPresented: $showError,
                message: errorMessage ?? "",
                retryAction: { Task { await reload() } }
            )
            .animation(.easeInOut, value: showFallbackBanner)
        }
    }

    // MARK: - Sections

    private var dateSelectionSection: some View {
        Section {
            DatePicker(
                "explore.screen.datepicker.section.title".localized(bundle: Bundle.module),
                selection: $viewModel.selectedDate,
                in: ...Date(),
                displayedComponents: .date
            )

            Button("explore.screen.loadAPOD.button.title".localized(bundle: Bundle.module)) {
                Task { await reload() }
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }

    @ViewBuilder
    private var contentSection: some View {
        if let apod = viewModel.apod {
            Section {
                if viewModel.isFallback {
                    Text("explore.screen.content.section.title".localized(bundle: Bundle.module))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text(apod.title)
                    .font(.headline)

                switch apod.mediaType {
                case .image:
                    if let url = apod.hdurl ?? apod.url {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(10)
                                    .shadow(radius: 4)
                            case .failure:
                                Text("explore.screen.content.section.image.load.failure.message".localized(bundle: Bundle.module))
                                    .foregroundColor(.secondary)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }

                case .video:
                    if let url = apod.url {
                        VideoWebView(url: url)
                            .frame(height: 300)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }

                case .other:
                    Text("explore.screen.content.section.unsupported.media.type.error.message".localized(bundle: Bundle.module))
                        .foregroundColor(.secondary)
                }

                Text(apod.explanation)
                    .font(.body)
                    .padding(.top, 8)
            }
        }
    }

    // MARK: - Logic

    private func reload() async {
        showError = false
        errorMessage = nil
        showFallbackBanner = false

        await viewModel.load(date: viewModel.selectedDate)

        await MainActor.run {
            if viewModel.apod == nil {
                showError = true
                errorMessage = "explore.screen.api.or.connection.failure.error.message".localized(bundle: Bundle.module)
            } else if viewModel.isFallback {
                showFallbackBanner = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showFallbackBanner = false
                    }
                }
            }
        }
    }
}
