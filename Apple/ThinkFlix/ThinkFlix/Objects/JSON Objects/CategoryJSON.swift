//
//  CategoryJSON.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 19.12.24.
//

import Foundation

internal struct CategoryJSON: Decodable {
    
    private let name : String
    
    private let id : UUID
}
