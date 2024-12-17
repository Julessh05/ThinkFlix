//
//  Persistence.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 15.12.24.
//

import CoreData

struct PersistenceController {
    static let local = PersistenceController(isLocal: true)
    
    static let cloud = PersistenceController(isLocal: false)

    @MainActor
    static let previewlocal: PersistenceController = {
        let result = PersistenceController(isLocal: true, inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let cat = Category(context: viewContext)
            cat.name = "Category \(i)"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(isLocal: Bool, inMemory: Bool = false) throws {
        if isLocal {
            container = NSPersistentCloudKitContainer(name: "ThinkFlix cloud")
            try container.persistentStoreCoordinator.addPersistentStore(
                type: .sqlite,
                at: FileManager.default.url(
                    for: .applicationSupportDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false
                )
            )
        } else {
            container = NSPersistentContainer(name: "ThinkFlix local")
        }
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}