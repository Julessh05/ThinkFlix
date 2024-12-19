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
            Text("Category: \(currentQuestion?.category?.name ?? "Category loading...")")
                .font(.subheadline)
                .padding(.top, 20)
            Spacer()
            Text(currentQuestion?.question ?? "Question loading...")
            Button("Skip question") {
                
            }
            Spacer()
            HStack {
                Button {
                    
                } label: {
                    Label("Correct", systemImage: "checkmark")
                        .foregroundStyle(.white)
                        .frame(width: 120, height: 60)
                        .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
                        .backgroundStyle(colorScheme == .dark ? .gray : .blue)
                }
                Button {
                    
                } label: {
                    Label("Wrong", systemImage: "xmark")
                        .foregroundStyle(.white)
                        .frame(width: 120, height: 60)
                        .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
                        .backgroundStyle(colorScheme == .dark ? .gray : .blue)
                }
            }
        }
        .navigationTitle(currentPlayer?.name ?? "Player")
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
    
    /// Function to use when entering next turn.
    /// This is only used when the game speed is set to roundUp
    private func nextTurn() -> Void {
        updateCurrentQuestion()
        guard currentPlayer != nil else {
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
    NavigationStack {
        GameView()
            .environment(\.managedObjectContext, container.container.viewContext)
            .environmentObject(gameConfig)
    }
}
