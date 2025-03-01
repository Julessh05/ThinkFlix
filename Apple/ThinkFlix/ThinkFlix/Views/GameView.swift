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
    
    /// The fact in the facts object
    @State private var currentFact : FactJSON? = nil
    
    /// All the different versions of the fact as strings in an array to loop over
    @State private var currentFactVersions : [String] = Array(repeating: "", count: 4)
    
    /// Whether a single fact version is shown in a big container in the middle of the screen or not
    @State private var factShownBig : Bool = false
    
    /// The index of the fact version shown big, as index of the array 'currentFactVersions'
    @State private var factNumberShownBig : Int = 0
    
    /// Whether or not the fact version that has been checked in by the user is correct
    @State private var factCorrect : Bool? = nil
    
    /// Whether or not the user has checked in his answer
    @State private var factCheckedIn : Bool = false
    
    /// Whether or not the correct answer is shown
    @State private var answerShown : Bool = false
    
    
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
                } else {
                    facts = try Storage.loadFactsFor(categories: gameConfig.categories)
                }
                nextTurn()
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
//            TODO: check this line: factCorrect = answerShown (Shouldn't be here, works with facts in quizCore View
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
                factCorrect = factNumberShownBig == currentFactVersions.firstIndex(where: { $0 == currentFact!.correct })
                if factCorrect! {
                    if factCheckedIn {
                        updateCurrentFact()
                    } else {
                        factCheckedIn = true
                        answerCorrect()
                    }
                } else if factCheckedIn {
                    nextTurn()
                } else {
                    factCheckedIn = true
                }
            } label: {
                if factCheckedIn {
                    Label("Next fact", systemImage: "arrow.clockwise")
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
                answerShown = false
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
                factCorrect = nil
            }
        } label: {
            Label("Show \(answerShown ? "fact" : "answer")", systemImage: "checkmark.bubble")
        }
    }
    
    /// Builds the container for the specified fact
    @ViewBuilder
    private func factContainer(_ fact : String) -> some View {
        Button {
            if !answerShown {
                withAnimation {
                    factShownBig.toggle()
                    factNumberShownBig = currentFactVersions.firstIndex(where: { $0 == fact })!
                    factCorrect = nil
                    factCheckedIn = false
                }
            } else if factShownBig {
                updateCurrentFact()
            } else if answerShown {
                // factShownBig is false and answerShown is true
                answerShown = false
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
    
    /// Returns the background color specified by the current state of the game
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
    
    /// Updates the current question to a new, randomly selected, not yet displayed fact, included in the selected
    /// question categories
    private func updateCurrentQuestion() -> Void {
        guard let question = questions.randomElement() else {
            gameConfig.gameOver = true
            return
        }
        currentQuestion = question
        questions.removeAll(where: { $0.question == question.question })
    }
    
    /// Updates the current fact to a new, randomly selected, not yet displayed fact, included in the selected
    /// fact categories
    private func updateCurrentFact() -> Void {
        factCheckedIn = false
        factCorrect = nil
        factShownBig = false
        answerShown = false
        guard let fact = facts.randomElement() else {
            gameConfig.gameOver = true
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
        if gameConfig.gameMode == .quizCore {
            updateCurrentQuestion()
        } else {
            updateCurrentFact()
        }
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
    
    /// Called when the answer is correct
    private func answerCorrect() -> Void {
        if currentPlayerStreak == 2 {
            maxStreakPlayer = currentPlayer
            nextTurn()
            endOfStreakShown.toggle()
        } else {
            // Increase points
            currentPlayer?.answered += 1
            currentPlayerStreak += 1
            if gameConfig.gameMode == .quizCore {
                updateCurrentQuestion()
            } else {
                // Do nothing, because fact is only updated when the user clicks "next fact"
            }
        }
        if currentPlayer?.answered == gameConfig.goal {
            gameConfig.endGame()
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
