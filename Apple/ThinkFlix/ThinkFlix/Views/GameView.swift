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
    
    @State private var questions : [Question] = []
    
    @State private var currentQuestion : Question? = nil
    
    @State private var gameOver : Bool = false
    
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
}

#Preview {
    let container = PersistenceController.preview
    let gameConfig = GameConfig(categories: [], player: [])
    GameView()
        .environment(\.managedObjectContext, container.container.viewContext)
        .environmentObject(gameConfig)
}
