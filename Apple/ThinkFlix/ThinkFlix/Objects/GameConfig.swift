//
//  GameConfig.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 17.12.24.
//

import Foundation

internal final class GameConfig : ObservableObject {
    
//    @Published internal var categories : [Category]
    @Published internal var categories : [CategoryJSON]
    
//    @Published internal var player : [Player]
    @Published internal var player : [GamePlayer]?
    
    @Published internal var gameMode : GameMode
    
    @Published internal var speed : GameSpeed
    
    @Published internal var gameRunning : Bool = false
    
    internal init(
        categories : [CategoryJSON],
        player : [GamePlayer]?,
        gameMode : GameMode,
        speed : GameSpeed
    ) {
        self.categories = categories
        self.player = player
        self.gameMode = gameMode
        self.speed = speed
    }
    
    internal init() {
        self.categories = []
        self.player = nil
        self.gameMode = .quizCore
        self.speed = .roundUp
    }
}
