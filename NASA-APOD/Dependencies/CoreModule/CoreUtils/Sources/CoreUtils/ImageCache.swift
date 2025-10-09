//
//  ImageCache.swift
//  CoreUtils
//
//  Created by Manik on 08/10/2025.
//

import Foundation
import UIKit

public actor ImageCache {
    public static let shared = ImageCache()

    private let mem = NSCache<NSURL, NSData>()
    private let diskURL: URL

    public init() {
        let support = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        diskURL = support.appendingPathComponent("APODImages", isDirectory: true)
        try? FileManager.default.createDirectory(at: diskURL, withIntermediateDirectories: true)
    }

    public func data(for url: URL) async -> Data? {
        if let cached = mem.object(forKey: url as NSURL) {
            return Data(referencing: cached)
        }
        let file = diskURL.appendingPathComponent(fileName(for: url))
        if let d = try? Data(contentsOf: file) {
            mem.setObject(NSData(data: d), forKey: url as NSURL)
            return d
        }
        return nil
    }

    public func store(data: Data, for url: URL) async {
        mem.setObject(NSData(data: data), forKey: url as NSURL)
        let file = diskURL.appendingPathComponent(fileName(for: url))
        try? data.write(to: file, options: .atomic)
    }

    private func fileName(for url: URL) -> String {
        let hashed = String(url.absoluteString.hashValue)
        return hashed + "_" + url.lastPathComponent
    }
}
