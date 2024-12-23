//
//  Welcome.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 15.12.24.
//

import SwiftUI

struct Welcome: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var gameConfigShown : Bool = false
    
    
    var body: some View {
        VStack {
            Button {
                gameConfigShown.toggle()
            } label: {
                Label("New Game", systemImage: "play")
                    .foregroundStyle(.white)
                    .frame(width: 210, height: 70)
                    .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
                    .backgroundStyle(colorScheme == .dark ? .gray : .blue)
            }
            .sheet(isPresented: $gameConfigShown) {
                GameConfigView()
            }
//            NavigationLink {
//                StatisticsView()
//            } label: {
//                Label("Statistics", systemImage: "chart.bar")
//                    .foregroundStyle(.white)
//                    .frame(width: 210, height: 70)
//                    .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
//                    .backgroundStyle(colorScheme == .dark ? .gray : .blue)
//            }
        }
        .navigationTitle("ThinkFlix")
    }
}

#Preview {
    NavigationStack {
        Welcome()
    }
}
