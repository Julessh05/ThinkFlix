//
//  Question.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 12.12.24.
//

import Foundation

internal enum Difficulty {
    case easy
    case normal
    case hard
    case insane
}

internal struct Question {
    
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
    
    private func checkCacheForAnswered() -> Bool {
        // TODO: update function to check in cache if question was answered
        return false
    }
}
