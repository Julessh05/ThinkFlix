//
//  CategoryJSON.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 19.12.24.
//

import Foundation

internal struct CategoryJSON: Decodable, Equatable {
    
    internal let name : String
    
    internal let id : String
    
    internal let subcategories : [CategoryJSON]?
    
    private let masterCategoryID : String?
}
