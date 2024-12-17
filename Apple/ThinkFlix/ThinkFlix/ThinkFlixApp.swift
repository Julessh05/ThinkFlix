//
//  ThinkFlixApp.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 15.12.24.
//

import SwiftUI
import CoreData

@main
struct ThinkFlixApp: App {
    private let localController = PersistenceController.local
    private let cloudController = PersistenceController.cloud

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.cloudContext, cloudController.container.viewContext)
        }
    }
}

extension EnvironmentValues {
    var cloudContext: NSManagedObjectContext? {
        get { self[CloudContextKey.self] }
        set { self[CloudContextKey.self] = newValue }
    }
    
    var localContext: NSManagedObjectContext? {
        get { self[LocalContextKey.self] }
        set { self[LocalContextKey.self] = newValue }
    }
}

private struct CloudContextKey : EnvironmentKey {
    static let defaultValue: NSManagedObjectContext? = nil
}

private struct LocalContextKey : EnvironmentKey {
    static let defaultValue: NSManagedObjectContext? = nil
}
