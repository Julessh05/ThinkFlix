//
//  GameConfigView.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 16.12.24.
//

import SwiftUI

internal enum GameMode : CaseIterable, Identifiable {
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

internal enum GameSpeed : CaseIterable, Identifiable {
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

private enum GameGoal : String, Identifiable, CaseIterable {
    var id: Self { self }
    
    case short
    case standard
    case long
    case custom
    
    fileprivate func getGoalValue() -> Int {
        switch self {
            case .short:
                return 10
            case .standard:
                return 15
            case .long:
                return 30
            case .custom:
                return 0
        }
    }
    
    fileprivate func getImage() -> String {
        switch self {
            case .short:
                return "10.arrow.trianglehead.clockwise"
            case .standard:
                return "15.arrow.trianglehead.clockwise"
            case .long:
                return "30.arrow.trianglehead.clockwise"
            case .custom:
                return "arrow.trianglehead.clockwise"
        }
    }
}


internal struct GameConfigView: View {
    
    // Environment variables
    @Environment(\.dismiss) private var dismiss
    
    //    @Environment(\.managedObjectContext) private var context
    
    // Environment objects
    @EnvironmentObject private var gameConfig : GameConfig
    
    // General data
    //    @State private var allCategories : [Category] = []
    @State private var allCategories : [CategoryJSON] = []
    
    
    // game data
    @State private var selectedGameMode : GameMode = .quizCore
    
    @State private var selectedSpeed : GameSpeed = .roundUp
    
    @State private var selectedGameGoal : GameGoal = .standard
    
    @State private var selectedCategories : [CategoryJSON] = []
    
    @State private var usePlayer : Bool = true
    
    @State private var playerNames : [String] = Array(repeating: "", count: 2)
    
    @State private var customGoal : String = ""
    
    
    // Sheet control variables
    @State private var editNamesPresented : Bool = false
    
    
    // Error control variables
    @State private var errFetchingCategories : Bool = false
    
    @State private var errNotEnoughPlayer : Bool = false
    
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
                    if usePlayer {
                        withAnimation {
                            Picker("Speed", selection: $selectedSpeed) {
                                ForEach(GameSpeed.allCases, id: \.id) {
                                    speed in
                                    Label(speed.getCorrectName(), systemImage: speed.getImage())
                                }
                            }
                        }
                    }
                    Picker("Goal", selection: $selectedGameGoal) {
                        ForEach(GameGoal.allCases, id: \.id) {
                            goal in
                            Label("\(goal.rawValue.capitalized) \(goal == .custom ? "" : "(\(goal.getGoalValue()))")", systemImage: goal.getImage())
                        }
                    }
                    .onChange(of: selectedGameGoal) {
                        guard selectedGameGoal != .custom else { return }
                        customGoal = String(selectedGameGoal.getGoalValue())
                    }
                    if selectedGameGoal == .custom {
                        TextField("Enter custom goal", text: $customGoal)
                            .keyboardType(.numberPad)
                    }
                } header: {
                    Text("Game")
                } footer: {
                    Text("Configure your game and its parameters")
                }
                Section {
                    Toggle("Use custom player", isOn: $usePlayer.animation())
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
                        Button {
                            editNamesPresented.toggle()
                        } label: {
                            Label("Edit Names", systemImage: "person.2.badge.gearshape.fill")
                        }
                        .sheet(isPresented: $editNamesPresented) {
                            NameSheet(playerNames: $playerNames)
                        }
                    }
                } header: {
                    Text("Player")
                } footer: {
                    Text("Add all the player names, or disable them, if you'd like to play without players")
                }
                Section {
                    NavigationLink {
                        CategoryViewer(
                            selectedCategories: $selectedCategories,
                            in: allCategories
                        )
                    } label: {
                        Label("Edit categories", systemImage: "pencil.and.list.clipboard")
                            .foregroundStyle(.primary)
                    }
                } header: {
                    Text("Categories")
                } footer: {
                    Text("Select the categories you want to play with")
                }
            }
            .toolbarVisibility(.automatic, for: .automatic)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start") {
                        gameConfig.categories = selectedCategories
                        gameConfig.gameMode = selectedGameMode
                        gameConfig.speed = usePlayer ? selectedSpeed : .roundUp
                        gameConfig.goal = selectedGameGoal == .custom ? (Int(
                            customGoal
                        ) ?? GameGoal.standard.getGoalValue()) : selectedGameGoal
                            .getGoalValue()
                        if usePlayer && playerNames.count(where: { !$0.isEmpty }) > 1 {
                            gameConfig.player = playerNames.map({
                                return GamePlayer(name: $0, points: 0)
                                //                            let p = Player(context: context)
                                //                            p.name = $0
                                //                            p.points = 0
                                //                            return p
                            })
                        } else if usePlayer {
                            // Not enough player names entered
                            errNotEnoughPlayer.toggle()
                            return
                        }
                        gameConfig.gameRunning = true
                    }
                }
            }
        }
        .onAppear {
            do {
                allCategories = try Storage.loadCategoriesFromJSON()
                //                allCategories = try Storage.fetchCategories(with: context)
                selectedCategories = allCategories
                for category in allCategories {
                    if let subs = category.subcategories {
                        selectedCategories.append(contentsOf: subs)
                    }
                }
            } catch {
                errFetchingCategories.toggle()
            }
        }
        .alert("Not enough player", isPresented: $errNotEnoughPlayer) {
            
        } message: {
            Text("You have to enter at least two player names, or play without player names")
        }
        .alert("Error fetching categories", isPresented: $errFetchingCategories) {
            
        } message: {
            Text("Ann error rose, trying to fetch the categories from the storage")
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
                Section {
                    ForEach(0..<getNumberPlayer(), id: \.self) {
                        index in
                        TextField("Player \(String(index + 1))", text: $localPlayerNames[index])
                    }
                } header: {
                    Text("Names")
                } footer: {
                    // Display information / error message if a number smaller than 1 is entered as player number or is in cache of player number
                    if (Int(numberPlayer) ?? 2) < 1 || (
                        Int(numberPlayerCache) ?? 2) < 1
                    {
                        Text("A number greater than 0 has to be entered. If you do not want to enter player names, disable the use of players")
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
                    .disabled((Int(numberPlayer) ?? 0) < 1)
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
    @Previewable @StateObject var previewGameConfig = GameConfig(
        categories: [],
        player: [],
        gameMode: .factFusion,
        speed: .rapidFire
    )
    let previewContainer = PersistenceController.preview
    
    NameSheet(playerNames: $previewPlayerNames)
        .environment(\.managedObjectContext, previewContainer.container.viewContext)
        .environmentObject(previewGameConfig)
}
