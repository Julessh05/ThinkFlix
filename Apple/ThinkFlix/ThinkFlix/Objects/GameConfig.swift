//
//  GameConfig.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 17.12.24.
//

import Foundation

internal final class GameConfig : ObservableObject {
    
    @Published internal var categories : [Category]
    
    internal init(categories : [Category]) {
        self.categories = categories
    }
}
