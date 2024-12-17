//
//  MainView.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 16.12.24.
//

import SwiftUI

struct MainView: View {
    
    // TODO: update to private, is internal for preview
    @State internal var gameRunning : Bool = false
    
    var body: some View {
        NavigationStack {
            builder()
        }
    }
    
    @ViewBuilder
    private func builder() -> some View {
        if gameRunning {
            GameView()
        } else {
            Welcome()
        }
    }
}

#Preview("Game not running") {
    MainView()
}

#Preview("Game running") {
    MainView(gameRunning: true)
}
