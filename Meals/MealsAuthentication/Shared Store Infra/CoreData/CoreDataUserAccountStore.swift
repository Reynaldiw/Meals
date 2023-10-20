//
//  CoreDataUserAccountStore.swift
//  Meals
//
//  Created by Reynaldi on 20/10/23.
//

import CoreData
import Foundation

public final class CoreDataUserAccountStore {
    private static let modelName = "UserAccountStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataUserAccountStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Swift.Error {
        case modelNotFound
        case failedToLoadPersistentStores(Swift.Error)
    }
    
    public init(storeURL: URL) throws {
        guard let model = CoreDataUserAccountStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(name: CoreDataUserAccountStore.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentStores(error)
        }
    }
    
    func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        return try result.get()
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}
