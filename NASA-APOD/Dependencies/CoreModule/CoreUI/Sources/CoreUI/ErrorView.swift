//
//  ErrorView.swift
//  CoreUI
//
//  Created by Manik on 08/10/2025.
//

import UIKit

public final class ErrorView: UIView {
    public let messageLabel = UILabel()
    public let retryButton = UIButton(type: .system)
    private var retryAction: (() -> Void)?

    public init(message: String, onRetry: (() -> Void)? = nil) {
        self.retryAction = onRetry
        super.init(frame: .zero)
        setup(message: message)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup(message: String) {
        backgroundColor = Theme.background

        messageLabel.text = message
        messageLabel.textColor = Theme.text
        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.adjustsFontForContentSizeCategory = true

        retryButton.setTitle("Retry", for: .normal)
        retryButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        retryButton.isHidden = retryAction == nil

        let stack = UIStackView(arrangedSubviews: [messageLabel, retryButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20)
        ])
    }

    @objc private func retryTapped() {
        retryAction?()
    }
}
