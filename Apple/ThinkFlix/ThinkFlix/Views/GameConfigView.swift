//
//  GameConfigView.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 16.12.24.
//

import SwiftUI

internal enum GameMode : String, CaseIterable, Identifiable {
    var id: Self { self }
    
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

internal enum GameSpeed : String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case rapidFire
    case roundUp
    
    func getImage() -> String {
        switch self {
            case .rapidFire:
                return "bolt.circle"
            case .roundUp:
                return "arrow.trianglehead.2.clockwise.rotate.90"
        }
    }
    
    func getCorrectName() -> String {
        switch self {
            case .rapidFire:
                return "RapidFire"
            case .roundUp:
                return "RoundUp"
        }
    }
}


internal struct GameConfigView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedGameMode : GameMode = .quizCore
    
    @State private var selectedSpeed : GameSpeed = .roundUp
    
    @State private var usePlayer : Bool = true
    
    @State private var playerNames : [String] = Array(repeating: "", count: 2)
    
    @State private var editNamesPresented : Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Mode", selection: $selectedGameMode) {
                        ForEach(GameMode.allCases, id: \.id) {
                            mode in
                            Label(mode.getCorrectName(), systemImage: mode.getImage())
                        }
                    }
                    Picker("Speed", selection: $selectedSpeed) {
                        ForEach(GameSpeed.allCases, id: \.id) {
                            speed in
                            Label(speed.getCorrectName(), systemImage: speed.getImage())
                        }
                    }
                } header: {
                    Text("Game Mode")
                } footer: {
                    Text("Select your game mode and speed for this game")
                }
                Section {
                    Toggle("Use player", isOn: $usePlayer.animation())
                        .onChange(of: usePlayer) {
                            guard usePlayer else { return }
                            editNamesPresented.toggle()
                        }
                    if usePlayer {
                        ForEach(playerNames, id: \.self) {
                            name in
                            if !name.isEmpty {
                                HStack {
                                    Button(role: .destructive) {
                                        playerNames.removeAll(where: { $0 == name })
                                    } label: {
                                        Image(systemName: "person.fill.xmark")
                                    }
                                    .foregroundStyle(.primary)
                                    Text(name)
                                }
                            }
                        }
                    }
                    Button {
                        editNamesPresented.toggle()
                    } label: {
                        Label("Edit Names", systemImage: "person.2.badge.gearshape.fill")
                    }
                    .sheet(isPresented: $editNamesPresented) {
                        NameSheet(playerNames: $playerNames)
                    }
                } header: {
                    Text("Player")
                } footer: {
                    Text("Add all the player names, or disable them, if you'd like to play without players")
                }
                Section {
                    // TODO: implement category section
                } header: {
                    Text("Categories")
                } footer: {
                    Text("Select the categories you want to play with")
                }
            }
            .toolbarRole(.editor)
            .toolbarVisibility(.automatic, for: .automatic)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start") {
                        // TODO: implement Button
                    }
                }
            }
        }   
    }
}

internal struct NameSheet : View {
    @Environment(\.dismiss) private var dismiss
    
    // Number of Player
    @State private var numberPlayer : String = "2"
    
    @State private var numberPlayerCache : String = ""
    
    // Player names
    @Binding internal var playerNames : [String]
    
    @State private var localPlayerNames : [String] = Array(repeating: "", count: 2)
    
    @State private var localPlayerNameCache : [String] = []
    
    var body: some View {
        NavigationStack {
            List {
                Section("Player") {
                    TextField("Number Player", text: $numberPlayer)
                        .onChange(of: numberPlayer) {
                            guard !numberPlayer.isEmpty else { return }
                            numberPlayerCache = numberPlayer
                            localPlayerNameCache = localPlayerNames
                            localPlayerNames = Array(
                                repeating: "",
                                count: Int(numberPlayer) ?? 2
                            )
                            for i in 0..<localPlayerNameCache.count {
                                guard i < localPlayerNames.count else { return }
                                localPlayerNames[i] = localPlayerNameCache[i]
                            }
                        }
                }
                Section("Names") {
                    ForEach(0..<getNumberPlayer(), id: \.self) {
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
    
    /// Returns the number of Player either directly from the value, or from the cache.
    /// Return 2 otherwise, if both fail
    private func getNumberPlayer() -> Int {
        // (Int(numberPlayer) ?? Int(numberPlayerCache)) ?? 2 is shorthand for returning 'numberPlayer' as an Int if possible,(Int(numberPlayer) ?? Int(numberPlayerCache)) ?? 2) otherwise trying to return numberPlayerCache as an Int (for keeping number of Player when deleting current number in the field and waiting for new input), and otherwise reutrn 2
        return (Int(numberPlayer) ?? Int(numberPlayerCache)) ?? 2
    }
}

#Preview {
    GameConfigView()
}

#Preview("Name Sheet") {
    @Previewable @State var previewPlayerNames : [String] = Array(repeating: "", count: 2)
    NameSheet(playerNames: $previewPlayerNames)
}
