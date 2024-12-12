//
//  ContentView.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 12.12.24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var gameConfigShown : Bool = false
    
    @State private var gameRunning : Bool = false
    
    var body: some View {
        NavigationSplitView {
            builder()
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
#if os(iOS)
            .navigationTitle("ThinkFlix")
            .navigationBarTitleDisplayMode(.automatic)
#endif
        } detail: {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func builder() -> some View {
        if gameRunning {
            GameView(gameRunning: $gameRunning)
        } else {
            welcomeScreen()
        }
    }
    
    @ViewBuilder
    private func welcomeScreen() -> some View {
        VStack {
            NavigationLink {
                GameConfig(gameRunning: $gameRunning)
            } label: {
                Label("New Game", systemImage: "play")
                    .foregroundStyle(.white)
                    .frame(width: 210, height: 70)
                    .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
                    .backgroundStyle(colorScheme == .dark ? .gray : .blue)
            }
            Button {
                
            } label: {
                Label("Statistics", systemImage: "chart.bar")
                    .foregroundStyle(.white)
                    .frame(width: 210, height: 70)
                    .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
                    .backgroundStyle(colorScheme == .dark ? .gray : .blue)
            }
        }
    }
}

#Preview {
    ContentView()
}
