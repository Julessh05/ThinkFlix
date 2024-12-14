//
//  Storage.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 12.12.24.
//

import Foundation

internal struct Storage {
    
    internal static func loadCategories() -> [Category] {
        return []
    }
    
    private static func loadCategoriesFromSource() throws -> [Category] {
        let path = Bundle.main.path(forResource: "categories", ofType: "json")
        let data = try Data(contentsOf: URL(filePath: path!), options: .mappedIfSafe)
        let content = try JSONDecoder().decode(QuizContent.self, from: data)
        let latestVersion : Double
        do {
            latestVersion = try Network.fetchLatestVersion()
        } catch {
            return content.categories
        }
        if content.version < latestVersion {
            return try Network.fetchLatestCategories()
        } else {
            return content.categories
        }
    }
    
    private static func updateCategories() -> Void {
        
    }
    
    internal static func loadQuestions(category : Category) throws -> [Question] {
        return []
    }
    
    private static func loadQuestionsFromJSON(category : Category) throws -> [Question] {
        let path = Bundle.main.path(forResource: category.name, ofType: "json")
        let data = try Data(contentsOf: URL(filePath: path!), options: .mappedIfSafe)
        let questions =  try JSONDecoder().decode([Question].self, from: data)
        storeQuestionsToSystem(questions)
        return questions
    }
    
    private static func storeQuestionsToSystem(_ questions : [Question]) -> Void {
        
    }
    
    internal static func loadAllQuestionIDs() -> [UUID] {
        return []
    }
}
