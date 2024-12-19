//
//  QuestionJSON.swift
//  ThinkFlix Data Creation
//
//  Created by Julian Schumacher on 19.12.24.
//

import Foundation

internal struct QuestionJSON : Decodable {
    
    internal let question : String
    
    internal let answer : String
    
    internal let answered : Bool
    
    internal let categoryID : String
}
