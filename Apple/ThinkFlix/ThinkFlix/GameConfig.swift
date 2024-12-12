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
    
    @State private var numberPlayer : String = ""
    
    @State private var playerNames : [String] =  Array(repeating: "", count: 2)
    
    @State private var useNames : Bool = true
    
    @State private var nameConfigShown : Bool = false
    
    var body: some View {
        VStack {
            ForEach(GameMode.allCases, id: \GameMode.rawValue) {
                mode in
                Label(mode.rawValue, systemImage: mode.getImage())
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
            Button {
                nameConfigShown.toggle()
            } label: {
                Label("Edit Names", systemImage: "person.2.badge.gearshape")
            }
        }
#if os(iOS)
        .navigationTitle("New Game")
        .navigationBarTitleDisplayMode(.automatic)
#endif
    }
}

internal struct NameSheet : View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var numberPlayer : String = ""
    
    @Binding internal var playerNames : [String]
    
    @State private var localPlayerNames : [String] = Array(repeating: "", count: 2)
    
    var body: some View {
        NavigationStack {
            List {
                Section("Player") {
                    TextField("Number Player", text: $numberPlayer)
                        .onChange(of: numberPlayer) {
                            localPlayerNames = Array(repeating: "", count: Int(numberPlayer) ?? 2)
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
                        playerNames = localPlayerNames
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    GameConfig()
}
