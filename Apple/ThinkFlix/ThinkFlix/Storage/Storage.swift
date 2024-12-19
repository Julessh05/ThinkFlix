//
//  Storage.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 16.12.24.
//

import Foundation
import CoreData

internal struct Storage {
    
    private static let fm : FileManager = FileManager.default
    
    internal static let quizContentDBName : String = "quizContent.sqlite"
    
    internal static let userDBName : String = "userdata.sqlite"
    
    internal static func loadCategoriesFromJSON() -> [CategoryJSON] {
        
    }
    
    
    internal static func checkDatabases(with context : NSManagedObjectContext) throws -> Void {
        let url = try fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appending(path: quizContentDBName, directoryHint: .notDirectory)
        if !fm.fileExists(atPath: url.path(percentEncoded: false)) {
            try copyDatabase()
        } else {
            // Test for new Version
            let fr = DB_Management.fetchRequest()
            let r = try context.fetch(fr)
            // TODO: update to test between current core data version and current sqlite file version
            if !r.isEmpty && r.first!.version >= 1.0 {
                // TODO: update database
            }
        }
    }
    
    private static func copyDatabase() throws -> Void {
        guard let path : String = Bundle.main.path(forResource: "quizContent", ofType: "sqlite") else {
            throw InitialDatabaseNotFoundError()
        }
        try fm.copyItem(
            at: URL(filePath: path),
            to: try fm.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appending(path: quizContentDBName, directoryHint: .notDirectory)
        )
    }
    
    internal static func fetchQuestions(with context : NSManagedObjectContext, for categories : [Category]) throws -> [Question] {
        let fetchRequest = Question.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category.uuid IN %@", categories.map({ $0.uuid! }))
        return try context.fetch(fetchRequest)
    }
    
    internal static func fetchCategories(with context : NSManagedObjectContext) throws -> [Category] {
        let fetchRequest = Category.fetchRequest()
        let categories : [Category] = try context.fetch(fetchRequest)
        return categories
    }
}
