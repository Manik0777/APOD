//
//  CoreDataStack.swift
//  CoreUtils
//
//  Created by Manik on 07/10/2025.
//

import Foundation
import CoreData

public final class CoreDataStack {
    public let container: NSPersistentContainer

    /// Default to NASA_APOD model if not provided.
    public init(modelName: String = "NASA_APOD") {
        // Try to load compiled model at modelName.momd
        if let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd"),
           let model = NSManagedObjectModel(contentsOf: modelURL) {
            container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        } else if let merged = NSManagedObjectModel.mergedModel(from: nil) {
            // fallback: merged model (works if model is in bundle)
            container = NSPersistentContainer(name: modelName, managedObjectModel: merged)
        } else {
            fatalError("Failed to load Core Data model named \(modelName)")
        }

        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("CoreData load error: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
      //  container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        // To do: 
    }

    public var context: NSManagedObjectContext { container.viewContext }

    public func saveContext() throws {
        let ctx = context
        if ctx.hasChanges { try ctx.save() }
    }
}
