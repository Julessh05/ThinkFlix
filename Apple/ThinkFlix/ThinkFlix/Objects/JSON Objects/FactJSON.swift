//
//  FactJSON.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 20.12.24.
//

import Foundation

internal struct FactJSON : Decodable {
    internal let correct : String
    
    internal let wrongFirst : String
    
    internal let wrongSecond : String
    
    internal let wrongThird : String
    
    internal let categoryID : String
}
