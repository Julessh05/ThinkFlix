//
//  GameView.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 16.12.24.
//

import SwiftUI
import CoreData

internal struct GameView: View {
    @Environment(\.localContext) private var gameContext
    
    @EnvironmentObject private var gameConfig : GameConfig
    
    @State private var questions : [Question] = []
    
    @State private var currentQuestion : Question? = nil
    
    @State private var gameOver : Bool = false
    
    var body: some View {
        VStack {
            Text(currentQuestion?.question ?? "Current Question")
            Button {
                
            } label: {
                
            }
        }
        .navigationTitle(currentQuestion?.category?.name ?? "Category")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        .onAppear {
            questions = Storage.fetchQuestions(
                with: gameContext!,
                for: gameConfig.categories
            )
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
    let container = PersistenceController.previewlocal
    let gameConfig = GameConfig(categories: [])
    GameView()
        .environment(\.localContext, container.container.viewContext)
        .environmentObject(gameConfig)
}
