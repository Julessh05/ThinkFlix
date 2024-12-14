//
//  Question.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 12.12.24.
//

import Foundation
import SwiftData

internal enum Difficulty : Codable {
    case easy
    case normal
    case hard
    case insane
}

@Model
internal final class Question : Codable {
    
    internal var id : UUID
    
    internal var question : String
    
    internal var answer : String
    
    internal var difficulty : Difficulty
    
    internal var answered : Bool = false
    
    internal init(
        id : UUID,
        question : String,
        answer : String,
        difficulty : Difficulty
    ) {
        self.id = id
        self.question = question
        self.answer = answer
        self.difficulty = difficulty
        self.answered = checkCacheForAnswered()
    }
    
    private enum QuestionCodingKeys : CodingKey {
        case id
        case question
        case answer
        case difficulty
        case answered
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: QuestionCodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.question = try container.decode(String.self, forKey: .question)
        self.answer = try container.decode(String.self, forKey: .answer)
        self.difficulty = try container.decode(Difficulty.self, forKey: .difficulty)
        self.answered = try container.decode(Bool.self, forKey: .answered)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: QuestionCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(question, forKey: .question)
        try container.encode(answer, forKey: .answer)
        try container.encode(difficulty, forKey: .difficulty)
        try container.encode(answered, forKey: .answered)
    }
    
    /// Checks if the question was already answered by the user and is therefore in the cache
    private func checkCacheForAnswered() -> Bool {
        // TODO: implement function to check in cache if question was answered
        return false
    }
}
