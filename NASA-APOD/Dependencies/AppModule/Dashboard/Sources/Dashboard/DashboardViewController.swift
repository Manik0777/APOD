//
//  DashboardViewController.swift
//  Dashboard
//
//  Created by Manik on 07/10/2025.
//

import UIKit
import Model
import CoreUI
import SwiftUI
import CoreUtils

public final class DashboardViewController: UIViewController {
    private let viewModel: DashboardViewModel
    private let dashboardView = DashboardView()
    private var hostingController: UIViewController?
    private var errorView: ErrorView?
    private var spinner: UIActivityIndicatorView?
    private let scrollView = UIScrollView()

    public init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "dashboard.screen.navigation.title".localized(bundle: Bundle.module)
    }

    required init?(coder: NSCoder) { fatalError() }

    public override func loadView() {
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = Theme.background

        scrollView.addSubview(dashboardView)
        dashboardView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dashboardView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            dashboardView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            dashboardView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            dashboardView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            dashboardView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        view = scrollView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        loadData()
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }

    @objc private func refreshTriggered() {
        Task {
            await viewModel.loadToday()
            await MainActor.run {
                updateUI()
                scrollView.refreshControl?.endRefreshing()
                showToast(message: "Fetching today's APOD...")
            }
        }
    }

    private func loadData() {
        showLoadingSpinner()
        Task {
            await viewModel.loadToday()
            await MainActor.run {
                updateUI()
            }
        }
    }

    @MainActor
    private func updateUI() {
        if let apod = viewModel.apod {
            errorView?.removeFromSuperview()
            show(apod: apod)
        } else {
            hideLoadingSpinner()
            showError(message: "dashboard.screen.api.or.connection.failure.error.message".localized(bundle: Bundle.module))
        }
    }

    @MainActor
    private func show(apod: APOD) {
        dashboardView.titleLabel.text = apod.title

        if viewModel.isFallback {
            dashboardView.dateLabel.text = "dashboard.screen.content.section.title".localized(bundle: Bundle.module)
        } else if let parsed = APODISOFormatter.shared.date(from: apod.date) {
            dashboardView.dateLabel.text = APODDisplayFormatter.shared.string(from: parsed)
        } else {
            dashboardView.dateLabel.text = apod.date
        }

        dashboardView.textView.text = apod.explanation

        if let host = hostingController {
            host.willMove(toParent: nil)
            host.view.removeFromSuperview()
            host.removeFromParent()
            hostingController = nil
        }

        switch apod.mediaType {
        case .image:
            if let url = apod.hdurl ?? apod.url {
                dashboardView.imageView.isHidden = false
                dashboardView.imageView.setImage(from: url) { [weak self] in
                    self?.hideLoadingSpinner()
                }
            } else {
                hideLoadingSpinner()
            }

        case .video:
            if let url = apod.url {
                let web = VideoWebView(url: url)
                let host = UIHostingController(rootView: web)
                addChild(host)
                dashboardView.embedMediaView(host.view)
                host.didMove(toParent: self)
                hostingController = host
            }
            hideLoadingSpinner()

        case .other:
            hideLoadingSpinner()
            showError(message: "dashboard.screen.content.section.unsupported.media.type.error.message".localized(bundle: Bundle.module))
        }
    }

    @MainActor
    private func showError(message: String) {
        errorView?.removeFromSuperview()
        let error = ErrorView(message: message) { [weak self] in
            self?.loadData()
        }
        error.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(error)
        NSLayoutConstraint.activate([
            error.topAnchor.constraint(equalTo: view.topAnchor),
            error.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            error.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            error.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        errorView = error
    }

    // MARK: - Spinner

    private func showLoadingSpinner() {
        guard spinner == nil else { return }
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.spinner = spinner
    }

    private func hideLoadingSpinner() {
        spinner?.stopAnimating()
        spinner?.removeFromSuperview()
        spinner = nil
    }
    
    private func showToast(message: String, duration: TimeInterval = 3.0) {
        let banner = FallbackBanner(
            message: message,
            backgroundColor: .orange,
            alignment: .bottom       
        )

        let host = UIHostingController(rootView: banner)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(host)
        view.addSubview(host.view)

        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        host.didMove(toParent: self)

        host.view.alpha = 0
        UIView.animate(withDuration: 0.3) {
            host.view.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: 0.3, animations: {
                host.view.alpha = 0
            }) { _ in
                host.willMove(toParent: nil)
                host.view.removeFromSuperview()
                host.removeFromParent()
            }
        }
    }

}
