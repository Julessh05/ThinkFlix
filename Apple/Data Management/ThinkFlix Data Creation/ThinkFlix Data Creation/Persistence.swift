//
//  Persistence.swift
//  ThinkFlix Data Creation
//
//  Created by Julian Schumacher on 19.12.24.
//

import Foundation
import CoreData

struct PersistenceController {
    
    static let export : PersistenceController = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "ThinkFlix")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let exportPath : String
            do {
                let path = Bundle.main.url(forResource: "exportPath", withExtension: nil)
                exportPath = try String(data: Data(contentsOf: path!), encoding: .utf8)!
            } catch {
                exportPath = "/dev/null"
                print("Error exporting database")
            }
            let localDescription = NSPersistentStoreDescription(url: URL(string: exportPath)!)
            localDescription.configuration = "LocalConfig"
            container.persistentStoreDescriptions = [localDescription]
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Error while loading Persistent Stores")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
