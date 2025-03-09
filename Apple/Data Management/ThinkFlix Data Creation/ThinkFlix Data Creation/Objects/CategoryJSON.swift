//
//  CategoryJSON.swift
//  ThinkFlix Data Creation
//
//  Created by Julian Schumacher on 19.12.24.
//

import Foundation

internal struct CategoryJSON : Codable {
    
    internal let name : String
    
    internal let id : String
    
    internal let subcategories : [CategoryJSON]?
}
