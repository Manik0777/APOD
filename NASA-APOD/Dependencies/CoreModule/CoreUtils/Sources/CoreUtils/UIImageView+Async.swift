//
//  Extensions.swift
//  CoreUtils
//
//  Created by Manik on 07/10/2025.
//

import UIKit

public extension UIImageView {
    func setImage(from url: URL?, completion: (() -> Void)? = nil) {
        guard let url = url else {
            completion?()
            return
        }

        Task {
            // Try in-memory/disk cache through ImageCache
            if let data = await ImageCache.shared.data(for: url), let img = UIImage(data: data) {
                await MainActor.run {
                    self.image = img
                    completion?()
                }
                return
            }

            // Otherwise fetch from network
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let img = UIImage(data: data) {
                    await MainActor.run {
                        self.image = img
                        completion?()
                    }
                    await ImageCache.shared.store(data: data, for: url)
                } else {
                    await MainActor.run { completion?() }
                }
            } catch {
                await MainActor.run {
                    self.image = nil
                    completion?()
                }
            }
        }
    }
}

