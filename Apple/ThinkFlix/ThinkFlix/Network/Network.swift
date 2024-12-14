//
//  Network.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 14.12.24.
//

import Foundation

// TODO: implement Network struct
internal struct Network {
    
    internal static func fetchLatestVersion() throws -> Double {
        return 1.0
    }
    
    internal static func fetchLatestCategories() throws -> [Category] {
        return []
    }
}
