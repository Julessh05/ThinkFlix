//
//  GameView.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 12.12.24.
//

import SwiftUI
import SwiftData

struct GameView: View {
    
    @Binding internal var gameRunning : Bool
    
    @State private var questions : [Question] = []
    
    var body: some View {
        VStack {
            
        }
        .onAppear {
        }
    }
}

#Preview {
    @Previewable @State var gameRunning: Bool = false
    GameView(gameRunning: $gameRunning)
}
