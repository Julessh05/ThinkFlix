//
//  Storage.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 16.12.24.
//

import Foundation
import CoreData

internal struct Storage {
    
    internal static func copyDatabase() throws -> Void {
        let path = Bundle.main.path(forResource: "questions", ofType: "sqlite")
    }
    
    internal static func fetchQuestions(with context : NSManagedObjectContext, for categories : [Category]) -> [Question] {
        return []
    }
}
