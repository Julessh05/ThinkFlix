//
//  Category.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 13.12.24.
//

import Foundation
import SwiftData

@Model
internal final class Category : Codable {
    
    internal var name : String
    
    internal var subcategories : [Category]
    
    internal init(name : String, subcategories : [Category]) {
        self.name = name
        self.subcategories = subcategories
    }
    
    private enum CategoryCodingKeys : CodingKey {
        case name
        case subcategories
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CategoryCodingKeys.self)
        try self.name = container.decode(String.self, forKey: .name)
        try self.subcategories = container.decode([Category].self, forKey: .subcategories)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CategoryCodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(subcategories, forKey: .subcategories)
    }
}
