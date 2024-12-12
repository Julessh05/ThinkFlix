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
    
    var body: some View {
        NavigationSplitView {
            VStack {
                NavigationLink {
                    GameConfig()
                } label: {
                    Label("New Game", systemImage: "play")
                        .foregroundStyle(.white)
                        .frame(width: 210, height: 70)
                        .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
                        .backgroundStyle(colorScheme == .dark ? .gray : .blue)
                }
                Button {
                    gameConfigShown.toggle()
                } label: {
                    Label("New Game", systemImage: "play")
                        .foregroundStyle(.white)
                        .frame(width: 210, height: 70)
                        .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
                        .backgroundStyle(colorScheme == .dark ? .gray : .blue)
                }
#if os(iOS)
                .sheet(isPresented: $gameConfigShown) {
                    GameConfig()
                }
#endif
                Button {
                    
                } label: {
                    Label("Statistics", systemImage: "chart.bar")
                        .foregroundStyle(.white)
                        .frame(width: 210, height: 70)
                        .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
                        .backgroundStyle(colorScheme == .dark ? .gray : .blue)
                }
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
            }
#if os(iOS)
            .navigationTitle("ThinkFlix")
            .navigationBarTitleDisplayMode(.automatic)
#endif
        } detail: {
            EmptyView()
        }
    }
}

#Preview {
    ContentView()
}
