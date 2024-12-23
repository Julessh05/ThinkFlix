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
    
    internal static var categories : [CategoryJSON] = []
    
    internal static var questions : [QuestionJSON] = []
    
    internal static var facts : [FactJSON] = []
    
    internal static func loadCategoriesFromJSON() throws -> [CategoryJSON] {
        let decoder = JSONDecoder()
        let path = Bundle.main.path(forResource: "categories", ofType: "json")
        let jsonData = try Data(contentsOf: URL(filePath: path!), options: .mappedIfSafe)
        let cats = try decoder.decode([CategoryJSON].self, from: jsonData)
        categories = cats
        return cats
    }
    
    internal static func loadQuestionsFromJSON() throws -> [QuestionJSON] {
        let decoder = JSONDecoder()
        let path = Bundle.main.path(forResource: "questions", ofType: "json")
        let jsonData = try Data(contentsOf: URL(filePath: path!), options: .mappedIfSafe)
        let qu = try decoder.decode([QuestionJSON].self, from: jsonData)
        questions = qu
        return qu
    }
    
    internal static func loadQuestionsFor(categories : [CategoryJSON]) throws -> [QuestionJSON] {
        if questions.isEmpty {
            let _ = try loadQuestionsFromJSON()
        }
        return questions.filter { categories.map(\.id).contains($0.categoryID) }
    }
    
    internal static func loadFactsFromJSON() throws -> [FactJSON] {
        let decoder = JSONDecoder()
        let path = Bundle.main.path(forResource: "facts", ofType: "json")
        let jsonData = try Data(contentsOf: URL(filePath: path!), options: .mappedIfSafe)
        let f = try decoder.decode([FactJSON].self, from: jsonData)
        facts = f
        return f
    }
    
    internal static func loadFactsFor(categories : [CategoryJSON]) throws -> [FactJSON] {
        if facts.isEmpty {
            let _ = try loadFactsFromJSON()
        }
        return facts.filter { categories.map(\.id).contains($0.categoryID) }
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
