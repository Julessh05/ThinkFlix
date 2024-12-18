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
    
    // Question objects
    @State private var questions : [Question] = []
    
    // Current data
    @State private var currentQuestion : Question? = nil
    
    @State private var currentPlayer : Player? = nil
    
    @State private var currentPlayerIndex : Int = 0
    
    /// Whether the game is over or not
    @State private var gameOver : Bool = false
    
    
    // Error control variables
    @State private var errFetchingQuestionsPresented : Bool = false
    
    var body: some View {
        VStack {
            Text(currentQuestion?.question ?? "Question loading...")
            Button {
                
            } label: {
                
            }
        }
        .navigationTitle(currentQuestion?.category?.name ?? "Category loading...")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        .onAppear {
            do {
                questions = try Storage.fetchQuestions(
                    with: gameContext,
                    for: gameConfig.categories
                )
                updateCurrentQuestion()
            } catch {
                errFetchingQuestionsPresented.toggle()
            }
        }
        .alert("Error loading Questions", isPresented: $errFetchingQuestionsPresented) {
            
        } message: {
            Text("There's been an error while fetching the questions. Please restart the App and try again.")
        }
    }
    
    private func updateCurrentQuestion() -> Void {
        guard let question = questions.randomElement() else {
            gameOver = true
            return
        }
        currentQuestion = question
        questions.removeAll(where: { $0.id == question.id })
    }
    
    /// Function to use when entering next turn
    private func nextTurn() -> Void {
        updateCurrentQuestion()
        guard let p = currentPlayer else {
            currentPlayer = gameConfig.player.first!
            currentPlayerIndex = 0
            return
        }
        if currentPlayerIndex == gameConfig.player.count - 1 {
            currentPlayerIndex = 0
        } else {
            currentPlayerIndex += 1
        }
        currentPlayer = gameConfig.player[currentPlayerIndex]
    }
}

#Preview {
    let container = PersistenceController.preview
    let gameConfig = GameConfig(categories: [], player: [])
    GameView()
        .environment(\.managedObjectContext, container.container.viewContext)
        .environmentObject(gameConfig)
}
