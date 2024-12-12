//
//  GameView.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 12.12.24.
//

import SwiftUI

struct GameView: View {
    
    @Binding internal var gameRunning : Bool
    
    var body: some View {
        VStack {
            
        }
    }
}

#Preview {
    @Previewable @State var gameRunning: Bool = false
    GameView(gameRunning: $gameRunning)
}
