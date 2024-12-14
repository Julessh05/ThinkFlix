//
//  QuizContent.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 14.12.24.
//

import Foundation

internal struct QuizContent : Codable {
    internal let version : Double
    
    internal let categories : [Category]
}
