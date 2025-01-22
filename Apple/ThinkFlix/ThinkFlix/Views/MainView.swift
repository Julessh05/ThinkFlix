//
//  MainView.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 16.12.24.
//

import SwiftUI

struct MainView: View {
    
    // TODO: update to private, is internal for preview
    @StateObject private var gameConfig : GameConfig = GameConfig()
    
    var body: some View {
        NavigationStack {
            builder()
        }
    }
    
    @ViewBuilder
    private func builder() -> some View {
        if gameConfig.gameRunning {
            GameView()
                .environmentObject(gameConfig)
        } else if gameConfig.gameOver {
            GameEndView()
                .environmentObject(gameConfig)
        } else {
            Welcome()
                .environmentObject(gameConfig)
        }
    }
}

#Preview("Game not running") {
    MainView()
}
