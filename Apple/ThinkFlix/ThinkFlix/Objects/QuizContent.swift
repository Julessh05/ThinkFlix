//
//  QuizContent.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 14.12.24.
//

import Foundation

internal struct QuizContent : Codable {
    let version : Double
    
    let categories : [Category]
}
