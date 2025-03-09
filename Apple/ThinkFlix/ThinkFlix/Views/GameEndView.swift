//
//  GameEndView.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 06.01.25.
//

import SwiftUI

struct GameEndView: View {
    
    @EnvironmentObject private var gameConfig : GameConfig
    
    @State private var bestPlayer : GamePlayer? = nil
    
    var body: some View {
        List {
            if gameConfig.player != nil {
                Section("Best player") {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(bestPlayer?.name ?? "best player")
                    }
                    HStack {
                        Text("Points")
                        Spacer()
                        Text(String(bestPlayer?.points ?? 0))
                    }
                    HStack {
                        Text("Correct answers")
                        Spacer()
                        Text(String(bestPlayer?.answered ?? 0))
                    }
                }
                Section("Player statistics") {
                    ForEach(gameConfig.player!, id: \GamePlayer.name) {
                        player in
                        HStack {
                            Text(player.name)
                            Spacer()
                            Text("\(player.points) Points")
                        }
                    }
                }
            } else {
                Text("No player statistics available")
            }
        }
        .navigationTitle("Overview")
        .navigationBarTitleDisplayMode(.automatic)
        .toolbarRole(.automatic)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    gameConfig.gameOver = false
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        .onAppear {
            calculateBestPlayer()
        }
    }
    
    @ViewBuilder
    private func buildPlayerList() -> some View {
        ForEach(gameConfig.player!, id: \.name) {
            player in
            HStack {
                Text(player.name)
                Spacer()
                Text("\(player.points) Points")
            }
        }
    }
    
    /// Calculate the best Player
    private func calculateBestPlayer() -> Void {
        guard gameConfig.player != nil else { return }
        bestPlayer = gameConfig.player!.first
        for player in gameConfig.player! {
            if player.points > bestPlayer!.points {
                bestPlayer = player
            }
        }
    }
}

#Preview("Game end with players") {
    let gameConfig = GameConfig(
        categories: [],
        player: [
            GamePlayer(name: "Test player", points: 100)
        ],
        gameMode: .quizCore,
        speed: .roundUp
    )
    GameEndView()
        .environmentObject(gameConfig)
}

#Preview("Game end w/o players") {
    let gameConfig = GameConfig(
        categories: [],
        player: nil,
        gameMode: .quizCore,
        speed: .roundUp
    )
    GameEndView()
        .environmentObject(gameConfig)
}
