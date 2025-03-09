//
//  GamePlayer.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 19.12.24.
//

import Foundation

/// A player in the game
internal final class GamePlayer : ObservableObject {
    
    /// The name of the player
    internal let name : String
    
    /// current points of the player
    @Published internal var points : Int = 0
    
    /// answered questions
    @Published internal var answered : Int = 0
    
    internal init(name : String) {
        self.name = name
    }
    
    internal convenience init(name : String, points : Int) {
        self.init(name: name)
        self.points = points
    }
}
