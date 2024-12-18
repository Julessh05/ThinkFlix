//
//  GameConfig.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 17.12.24.
//

import Foundation

internal final class GameConfig : ObservableObject {
    
    @Published internal var categories : [Category]
    
    @Published internal var player : [Player]
    
    internal init(categories : [Category], player : [Player]) {
        self.categories = categories
        self.player = player
    }
}
