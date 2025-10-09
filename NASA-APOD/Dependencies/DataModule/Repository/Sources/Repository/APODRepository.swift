//
//  APODRepository.swift
//  Repository
//
//  Created by Manik on 07/10/2025.
//

import Foundation
import CoreData
import Model
import APIClient
import CoreUtils

public protocol APODRepository: Sendable {
    /// Return APOD for `date` (nil => today). If network fails, repo should return cached value or nil.
    func getAPOD(for date: Date?) async -> APOD?
    /// Return image data for URL (may be cached)
    func getImageData(for url: URL) async -> Data?
}

public actor DefaultAPODRepository: APODRepository {
    private let api: APODAPI
    private let coreDataStack: CoreDataStack
    private let imageCache: ImageCache

    public init(api: APODAPI, coreDataStack: CoreDataStack, imageCache: ImageCache? = nil) {
        self.api = api
        self.coreDataStack = coreDataStack
        self.imageCache = imageCache ?? ImageCache.shared
    }

    public func getAPOD(for date: Date?) async -> APOD? {
        do {
            let apod = try await api.fetchAPOD(for: date)
            await saveAPOD(apod)
            return apod
        } catch {
            return await loadCachedAPOD(for: date)
        }
    }

    public func getImageData(for url: URL) async -> Data? {
        if let cached = await imageCache.data(for: url) {
            return cached
        }
        if let diskData = try? await loadImageDataFromDisk(url: url) {
            await imageCache.store(data: diskData, for: url)
            return diskData
        }
        if let fresh = try? await api.fetchImageData(for: url) {
            await imageCache.store(data: fresh, for: url)
            return fresh
        }
        return nil
    }
/*
    private func saveAPOD(_ apod: APOD) async {
        await coreDataStack.container.performBackgroundTask { ctx in
            do {
                let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedAPOD")
                try? ctx.execute(NSBatchDeleteRequest(fetchRequest: fr))
                guard let entity = NSEntityDescription.entity(forEntityName: "CachedAPOD", in: ctx) else { return }
                let obj = NSManagedObject(entity: entity, insertInto: ctx)
                obj.setValue(apod.date, forKey: "date")
                obj.setValue(apod.title, forKey: "title")
                obj.setValue(apod.explanation, forKey: "explanation")
                obj.setValue(apod.mediaType, forKey: "mediaType")
                obj.setValue(apod.url?.absoluteString, forKey: "url")
                obj.setValue(apod.hdurl?.absoluteString, forKey: "hdurl")
                try ctx.save()
            } catch {
                print("CoreData save error: \(error)")
            }
        }
    }

    private func loadCachedAPOD(for date: Date?) async -> APOD? {
        let ctx = coreDataStack.context
        let fr: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "CachedAPOD")
        fr.fetchLimit = 1
        if let result = try? ctx.fetch(fr).first {
            let date = result.value(forKey: "date") as? String ?? ""
            let title = result.value(forKey: "title") as? String ?? ""
            let explanation = result.value(forKey: "explanation") as? String ?? ""
            let mediaType = result.value(forKey: "mediaType") as? String ?? "image"
            let url = (result.value(forKey: "url") as? String).flatMap(URL.init)
            let hdurl = (result.value(forKey: "hdurl") as? String).flatMap(URL.init)
            return APOD(date: date, title: title, explanation: explanation,
                        mediaType: mediaType, url: url, hdurl: hdurl, copyright: nil)
        }
        return nil
    }
*/
    private func saveAPOD(_ apod: APOD) async {
        await coreDataStack.container.performBackgroundTask { ctx in
            do {
                let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedAPOD")
                try? ctx.execute(NSBatchDeleteRequest(fetchRequest: fr))
                guard let entity = NSEntityDescription.entity(forEntityName: "CachedAPOD", in: ctx) else { return }

                let obj = NSManagedObject(entity: entity, insertInto: ctx)
                obj.setValue(apod.date, forKey: "date")
                obj.setValue(apod.title, forKey: "title")
                obj.setValue(apod.explanation, forKey: "explanation")
                obj.setValue(apod.mediaType.rawValue, forKey: "mediaType")
                obj.setValue(apod.url?.absoluteString, forKey: "url")
                obj.setValue(apod.hdurl?.absoluteString, forKey: "hdurl")

                try ctx.save()
            } catch {
                print("CoreData save error: \(error)")
            }
        }
    }

    private func loadCachedAPOD(for date: Date?) async -> APOD? {
        let ctx = coreDataStack.context
        let fr: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "CachedAPOD")
        fr.fetchLimit = 1

        guard let result = try? ctx.fetch(fr).first else { return nil }

        let date = result.value(forKey: "date") as? String ?? ""
        let title = result.value(forKey: "title") as? String ?? ""
        let explanation = result.value(forKey: "explanation") as? String ?? ""
        let mediaTypeRaw = result.value(forKey: "mediaType") as? String ?? "image"
        let mediaType = APODMediaType(rawValue: mediaTypeRaw) ?? .other
        let url = (result.value(forKey: "url") as? String).flatMap(URL.init)
        let hdurl = (result.value(forKey: "hdurl") as? String).flatMap(URL.init)

        return APOD(
            date: date,
            title: title,
            explanation: explanation,
            mediaType: mediaType,
            url: url,
            hdurl: hdurl,
            copyright: nil
        )
    }
 
 private func loadImageDataFromDisk(url: URL) async throws -> Data? {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let path = caches.appendingPathComponent("APODImages/\(url.lastPathComponent)")
        return try? Data(contentsOf: path)
    }
}
