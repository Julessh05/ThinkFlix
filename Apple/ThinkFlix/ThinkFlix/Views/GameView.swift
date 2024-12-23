//
//  GameView.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 16.12.24.
//

import SwiftUI
import CoreData

internal struct GameView: View {
    @Environment(\.managedObjectContext) private var gameContext
    
    @EnvironmentObject private var gameConfig : GameConfig
    
    @Environment(\.colorScheme) private var colorScheme
    
    /* Current Data */
    //    @State private var currentPlayer : Player? = nil
    @State private var currentPlayer : GamePlayer? = nil
    
    @State private var currentPlayerStreak : Int = 0
    
    @State private var currentPlayerIndex : Int = 0
    
    @State private var maxStreakPlayer : GamePlayer?
    
    
    /* QuizCore Variables */
    
    // Question objects
    //    @State private var questions : [Question] = []
    @State private var questions : [QuestionJSON] = []
    
    //    @State private var currentQuestion : Question? = nil
    @State private var currentQuestion : QuestionJSON? = nil
    
    
    /* FactFusion Variables */
    
    //    @State private var facts : [Fact] = []
    @State private var facts : [FactJSON] = []
    
    @State private var currentFact : FactJSON? = nil
    
    @State private var currentFactVersions : [String] = Array(repeating: "", count: 4)
    
    @State private var factShownBig : Bool = false
    
    @State private var factNumberShownBig : Int = 0
    
    @State private var factCorrect : Bool? = nil
    
    @State private var factCheckedIn : Bool = false
    
    
    
    @State private var answerShown : Bool = false
    
    /// Whether the game is over or not
    @State private var gameOver : Bool = false
    
    
    // Error control variables
    @State private var errFetchingQuestionsPresented : Bool = false
    
    
    // Dialog control variables
    @State private var endOfStreakShown : Bool = false
    
    var body: some View {
        VStack {
            //            Text("Category: \(currentQuestion?.category?.name ?? "Category loading...")")
            Text("\(gameConfig.gameMode.getCorrectName()) (\(gameConfig.speed.getCorrectName()))")
                .font(.subheadline)
                .padding(.top, 20)
            if gameConfig.gameMode == .quizCore {
                quizCoreView()
            } else {
                factFusionView()
            }
        }
        .navigationTitle(currentPlayer?.name ?? "ThinkFlix")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    gameConfig.gameRunning = false
                } label: {
                    Image(systemName: "xmark")
                }
                //                Menu {
                //
                //                } label: {
                //                    Image(systemName: "xmark")
                //                }
            }
        }
        .onAppear {
            do {
                if gameConfig.gameMode == .quizCore {
                    questions = try Storage.loadQuestionsFor(categories: gameConfig.categories)
                    //                questions = try Storage.fetchQuestions(
                    //                    with: gameContext,
                    //                    for: gameConfig.categories
                    //                )
                    updateCurrentQuestion()
                } else {
                    facts = try Storage.loadFactsFor(categories: gameConfig.categories)
                    updateCurrentFact()
                }
                currentPlayer = gameConfig.player?[currentPlayerIndex]
            } catch {
                errFetchingQuestionsPresented.toggle()
                print(error)
            }
        }
        .alert("End of streak", isPresented: $endOfStreakShown) {
            
        } message: {
            Text("The maximum streak of 3 questions in a row has been reached for \(maxStreakPlayer?.name ?? "this player"). It's now \(currentPlayer?.name ?? "the next player")'s turn")
        }
        .alert("Error loading Questions", isPresented: $errFetchingQuestionsPresented) {
            
        } message: {
            Text("There's been an error while fetching the questions. Please restart the App and try again.")
        }
    }
    
    
    /* BUILDERS */
    
    /// Builds the view for the QuizCore game mode
    @ViewBuilder
    private func quizCoreView() -> some View {
        Text("Answer:")
            .font(.headline)
            .opacity(answerShown ? 1 : 0)
        Text(answerShown ? (currentQuestion?.answer ?? "Answer loading...") : (currentQuestion?.question ?? "Question loading"))
            .multilineTextAlignment(.center)
            .foregroundStyle(.black)
            .frame(width: 300, height: 375)
            .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
            .backgroundStyle(.clear)
        Button("Skip question") {
            updateCurrentQuestion()
        }
        Spacer()
        Button {
            answerShown.toggle()
            factCorrect = answerShown
        } label: {
            Label("Show \(answerShown ? "question" : "answer")", systemImage: "checkmark.bubble")
        }
        .foregroundStyle(.white)
        .frame(width: 300, height: 60)
        .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
        .backgroundStyle(
            Gradient(
                colors: [
                    Color(
                        red: 0.6,
                        green: 0.8,
                        blue: 1.0
                    ),
                    Color(
                        red: 0.1,
                        green: 0.5,
                        blue: 0.9
                    )
                ]
            )
        )
        //            .shadow(radius: 10)
        Spacer()
        HStack {
            Spacer()
            Button {
                nextTurn()
            } label: {
                Label("Wrong", systemImage: "xmark")
                    .foregroundStyle(.white)
                    .frame(width: 120, height: 60)
                    .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
                    .backgroundStyle(
                        Gradient(
                            colors: [
                                Color(
                                    red: 1.0,
                                    green: 0.6,
                                    blue: 0.6
                                ),
                                Color(
                                    red: 0.7,
                                    green: 0.1,
                                    blue: 0.1
                                )
                            ]
                        )
                    )
                //                        .shadow(radius: 10)
            }
            Spacer()
            Button {
                answerCorrect()
            } label: {
                Label("Correct", systemImage: "checkmark")
                    .foregroundStyle(.white)
                    .frame(width: 120, height: 60)
                    .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
                    .backgroundStyle(
                        Gradient(
                            colors: [
                                Color(
                                    red: 0.6,
                                    green: 1.0,
                                    blue: 0.6
                                ),
                                Color(
                                    red: 0.1,
                                    green: 0.7,
                                    blue: 0.1
                                )
                            ]
                        )
                    )
                //                        .shadow(radius: 10)
            }
            Spacer()
        }
    }
    
    /// Builds the view for the FactFusion game mode
    @ViewBuilder
    private func factFusionView() -> some View {
        Spacer()
        if factShownBig {
            factContainer(currentFactVersions[factNumberShownBig])
            Button {
                if factCheckedIn {
                    updateCurrentFact()
                } else {
                    factCheckedIn = true
                    factCorrect = factNumberShownBig == currentFactVersions.firstIndex(where: { $0 == currentFact!.correct })
                }
            } label: {
                if factCheckedIn {
                    Label("Next fact", systemImage: "arrow")
                } else {
                    Label("Check in", systemImage: "checkmark")
                }
            }
        } else {
            VStack {
                HStack {
                    factContainer(currentFactVersions[0])
                    factContainer(currentFactVersions[1])
                }
                HStack {
                    factContainer(currentFactVersions[2])
                    factContainer(currentFactVersions[3])
                }
            }
            .multilineTextAlignment(.center)
            Button("Skip fact") {
                updateCurrentFact()
            }
        }
        Spacer()
        Button {
            if factCheckedIn {
                factNumberShownBig = currentFactVersions.firstIndex(of: currentFact!.correct)!
                factCorrect = true
            } else {
                answerShown.toggle()
            }
        } label: {
            Label("Show \(answerShown ? "fact" : "answer")", systemImage: "checkmark.bubble")
        }
    }
    
    
    @ViewBuilder
    private func factContainer(_ fact : String) -> some View {
        Button {
            if !factCheckedIn && !answerShown {
                withAnimation {
                    factShownBig.toggle()
                    factNumberShownBig = currentFactVersions.firstIndex(where: { $0 == fact })!
                }
            } else {
                updateCurrentFact()
            }
        } label: {
            Text(fact)
                .padding(.all, 20)
                .frame(width: factShownBig ? 350 : 175, height: factShownBig ? 350 : 175)
                .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
                .backgroundStyle(getFactBackgroundColor(fact: fact))
                .padding(.all, 10)
        }
        .foregroundStyle(.primary)
    }
    
    private func getFactBackgroundColor(fact : String) -> Color {
        let isGreen : Bool = (factCorrect != nil && factCorrect!) || (answerShown && fact == currentFact!.correct)
        let isRed : Bool = factCorrect != nil && !factCorrect! || answerShown && fact != currentFact!.correct
        if isGreen {
            return .green
        } else if isRed {
            return .red
        } else {
            return .blue
        }
    }
    
    /* Methods */
    
    private func updateCurrentQuestion() -> Void {
        guard let question = questions.randomElement() else {
            gameOver = true
            return
        }
        currentQuestion = question
        questions.removeAll(where: { $0.question == question.question })
    }
    
    private func updateCurrentFact() -> Void {
        factCheckedIn = false
        factCorrect = nil
        factShownBig = false
        guard let fact = facts.randomElement() else {
            gameOver = true
            return
        }
        currentFact = fact
        currentFactVersions = [
            currentFact?.correct ?? "Fact loading...",
            currentFact?.wrongFirst ?? "Fact loading...",
            currentFact?.wrongSecond ?? "Fact loading...",
            currentFact?.wrongThird ?? "Fact loading..."
        ].shuffled()
        facts.removeAll(where: { $0.correct == fact.correct })
    }
    
    /// Function to use when entering next turn.
    /// This is only used when the game speed is set to roundUp
    private func nextTurn() -> Void {
        updateCurrentQuestion()
        if gameConfig.speed == .roundUp {
            guard gameConfig.player != nil else {
                return
            }
            guard currentPlayer != nil else {
                currentPlayer = gameConfig.player!.first
                currentPlayerIndex = 0
                return
            }
            if currentPlayerIndex == gameConfig.player!.count - 1 {
                currentPlayerIndex = 0
            } else {
                currentPlayerIndex += 1
            }
            currentPlayer = gameConfig.player![currentPlayerIndex]
            currentPlayerStreak = 0
        } else {
            // TODO: implement RapidFire Mode
        }
    }
    
    private func answerCorrect() -> Void {
        if currentPlayerStreak == 2 {
            maxStreakPlayer = currentPlayer
            nextTurn()
            endOfStreakShown.toggle()
        } else {
            currentPlayer?.points += 1
            currentPlayerStreak += 1
            updateCurrentQuestion()
        }
    }
}

#Preview("QuizCore GameView") {
    let container = PersistenceController.preview
    let gameConfig = GameConfig(
        categories: [],
        player: [
            GamePlayer(name: "Test player")
        ],
        gameMode: .quizCore,
        speed: .roundUp
    )
    NavigationStack {
        GameView()
            .environment(\.managedObjectContext, container.container.viewContext)
            .environmentObject(gameConfig)
    }
}

#Preview("FactFusion GameView") {
    let container = PersistenceController.preview
    let gameConfig = GameConfig(
        categories: [],
        player: [
            GamePlayer(name: "Test player")
        ],
        gameMode: .factFusion,
        speed: .roundUp
    )
    NavigationStack {
        GameView()
            .environment(\.managedObjectContext, container.container.viewContext)
            .environmentObject(gameConfig)
    }
}
