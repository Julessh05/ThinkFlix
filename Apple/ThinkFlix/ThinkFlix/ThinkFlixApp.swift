//
//  ThinkFlixApp.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 12.12.24.
//

import SwiftUI
import SwiftData

@main
struct ThinkFlixApp: App {
    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Category.self,
            Question.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
