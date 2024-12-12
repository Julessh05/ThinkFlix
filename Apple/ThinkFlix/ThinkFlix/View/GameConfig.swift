//
//  GameConfig.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 12.12.24.
//

import SwiftUI

internal enum GameMode : String, CaseIterable {
    case quizCore
    case factFusion
    
    func getImage() -> String {
        switch self {
            case .quizCore:
                return "chart.pie"
            case .factFusion:
                return "text.page"
        }
    }
    
    func getCorrectName() -> String {
        switch self {
            case .quizCore:
                return "QuizCore"
            case .factFusion:
                return "FactFusion"
        }
    }
}

struct GameConfig: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var selectedGameMode : GameMode = .quizCore
    
    @State private var playerNames : [String] =  Array(repeating: "", count: 2)
    
    @State private var useNames : Bool = true
    
    @State private var nameConfigShown : Bool = false
    
    @Binding internal var gameRunning : Bool
    
    var body: some View {
        VStack {
            ForEach(GameMode.allCases, id: \GameMode.rawValue) {
                mode in
                Label(mode.getCorrectName(), systemImage: mode.getImage())
                    .foregroundStyle(.white)
                    .frame(width: 210, height: 70)
                    .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
                    .backgroundStyle(colorScheme == .dark ? .gray : .blue)
            }
            Toggle("Use names", isOn: $useNames.animation())
                .frame(width: 210, height: 70)
                .onChange(of: useNames) {
                    guard useNames else { return }
                    nameConfigShown.toggle()
                }
                .sheet(isPresented: $nameConfigShown) {
                    NameSheet(playerNames: $playerNames)
                }
            if playerNames.count(where: { !$0.isEmpty }) > 0 {
                Text("Players:")
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(playerNames, id: \.self) {
                        name in
                        if !name.isEmpty {
                            nameContainer(name)
                        } else {
                            EmptyView()
                        }
                    }
                }
            }
            Button {
                nameConfigShown.toggle()
            } label: {
                Label("Edit Names", systemImage: "person.2.badge.gearshape")
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Start") {
                    gameRunning = true
                }
            }
        }
#if os(iOS)
        .navigationTitle("New Game")
        .navigationBarTitleDisplayMode(.automatic)
#endif
    }
    
    @ViewBuilder
    private func nameContainer(_ name : String) -> some View {
        HStack {
            Button {
                playerNames.removeAll(where: { $0 == name })
            } label: {
                Image(systemName: "xmark")
            }
            Text(name)
        }
        .foregroundStyle(.white)
        .frame(width: 50 + (CGFloat(name.count) * 10), height: 50)
        .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
        .backgroundStyle(.blue)
    }
}

internal struct NameSheet : View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var numberPlayer : String = "2"
    
    @Binding internal var playerNames : [String]
    
    @State private var localPlayerNames : [String] = Array(repeating: "", count: 2)
    
    @State private var localPlayerNameCache : [String] = []
    
    var body: some View {
        NavigationStack {
            List {
                Section("Player") {
                    TextField("Number Player", text: $numberPlayer)
                        .onChange(of: numberPlayer) {
                            localPlayerNameCache = localPlayerNames
                            localPlayerNames = Array(repeating: "", count: Int(numberPlayer) ?? 2)
                            for i in 0..<localPlayerNameCache.count {
                                localPlayerNames[i] = localPlayerNameCache[i]
                            }
                        }
                }
                Section("Names") {
                    ForEach(0..<(Int(numberPlayer) ?? 2), id: \.self) {
                        index in
                        TextField("Player \(String(index + 1))", text: $localPlayerNames[index])
                    }
                }
            }
            .navigationTitle("Edit Names")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        numberPlayer = String(localPlayerNames.count(where: { !$0.isEmpty }))
                        localPlayerNames.removeAll(where: { $0.isEmpty })
                        playerNames = Array(repeating: "", count: Int(numberPlayer) ?? 2)
                        playerNames = localPlayerNames
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            numberPlayer = String(playerNames.count)
            localPlayerNames = playerNames
        }
    }
}

#Preview {
    @Previewable @State var gameRunning : Bool = false
    GameConfig(gameRunning: $gameRunning)
}

#Preview("Name Sheet") {
    @Previewable @State var previewPlayerNames : [String] = Array(repeating: "", count: 2)
    NameSheet(playerNames: $previewPlayerNames)
}
