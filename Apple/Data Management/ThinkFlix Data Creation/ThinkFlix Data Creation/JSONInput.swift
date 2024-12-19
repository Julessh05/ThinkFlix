//
//  JSONInput.swift
//  ThinkFlix Data Creation
//
//  Created by Julian Schumacher on 19.12.24.
//

import Foundation

internal struct JSONInput {
    
    internal static func readCategories() throws -> [CategoryJSON] {
        // TODO: does not work with multiple different categories.json
        let path = Bundle.main.url(forResource: "categories", withExtension: "json")!
        let jsonData = try Data(contentsOf: path)
        return try JSONDecoder().decode([CategoryJSON].self, from: jsonData)
    }
    
    internal static func readQuestions() throws -> [QuestionJSON] {
        // TODO: does not work with multiple different question.json
        let path = Bundle.main.url(forResource: "questions", withExtension: "json")!
        let jsonData = try Data(contentsOf: path)
        return try JSONDecoder().decode([QuestionJSON].self, from: jsonData)
    }
}
