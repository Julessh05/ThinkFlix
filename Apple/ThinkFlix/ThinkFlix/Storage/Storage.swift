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
    
    private static let fileName : String = "questions.sqlite"
    
    internal static func checkDatabases(with context : NSManagedObjectContext) throws -> Void {
        let url = try fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appending(path: fileName, directoryHint: .notDirectory)
        if !fm.fileExists(atPath: url.absoluteString) {
            try copyDatabase()
        } else {
            // Test for new Version
            let fr = DB_Management.fetchRequest()
            let r = try fr.execute()
            // TODO: update to test between current core data version and current sqlite file version
            if !r.isEmpty && r.first!.version >= 1.0 {
                
            }
        }
    }
    
    private static func copyDatabase() throws -> Void {
        guard let path : String = Bundle.main.path(forResource: "questions", ofType: "sqlite") else {
            throw InitialDatabaseNotFoundError()
        }
        try fm.copyItem(
            at: URL(string: path)!,
            to: try fm.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appending(path: fileName, directoryHint: .notDirectory)
        )
    }
    
    internal static func fetchQuestions(with context : NSManagedObjectContext, for categories : [Category]) throws -> [Question] {
        let fetchRequest = Question.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category.uuid IN %@", categories.map({ $0.uuid! }))
        return try fetchRequest.execute()
    }
    
    internal static func fetchCategories(with context : NSManagedObjectContext) throws -> [Category] {
        let fetchRequest = Category.fetchRequest()
        let categories = try fetchRequest.execute()
        return categories
    }
}
