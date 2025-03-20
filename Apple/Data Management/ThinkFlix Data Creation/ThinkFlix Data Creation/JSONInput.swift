//
//  JSONInput.swift
//  ThinkFlix Data Creation
//
//  Created by Julian Schumacher on 19.12.24.
//

import Foundation

internal struct JSONInput {
    
    /// File Manager for searching json files
    private static var fm : FileManager = .default
    
    internal static func readCategories() throws -> [CategoryJSON] {
        // TODO: does not work with multiple different categories.json
        guard let path = try searchDir(fm.currentDirectoryPath, for: "categories.json") else { exit(1) }
        return try JSONDecoder().decode([CategoryJSON].self, from: jsonData)
    }
    
    internal static func readQuestions() throws -> [QuestionJSON] {
        // TODO: does not work with multiple different question.json
        guard let paths = try searchDir(fm.currentDirectoryPath, for: "questions.json") else { exit(1) }
        let jsonData = try Data(contentsOf: path)
        return try JSONDecoder().decode([QuestionJSON].self, from: jsonData)
    }
    
    private static func searchDir(_ path : String, for search: String) throws -> URL? {
        for element in try fm.contentsOfDirectory(atPath: path) {
            let elementName = URL(
                fileURLWithPath: element
            ).lastPathComponent
            if elementName == search {
                return URL(fileURLWithPath: element)
            } else if fm.fileExists(atPath: <#T##String#>) {
                // if element is folder -> search folder
                // if element is file -> check file name
            }
        }
        return nil
    }
}
