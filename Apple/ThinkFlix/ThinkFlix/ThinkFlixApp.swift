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
    
    /// The controller used for locally stored data, such as questions and categories
    private let localController = PersistenceController.local
    
    /// The cloud controller, which is used for user and custom data, such as games and statistics
    private let cloudController = PersistenceController.cloud
    
    @State private var errLoadingDataShown : Bool = false

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.cloudContext, cloudController.container.viewContext)
                .environment(\.localContext, localController.container.viewContext)
                .onAppear {
                    do {
                        try Storage.checkDatabases(with: localController.container.viewContext)
                    } catch {
                        errLoadingDataShown.toggle()
                    }
                }
                .alert("Error loading Data", isPresented: $errLoadingDataShown) {
                    
                } message: {
                    Text("There's been an error while loading the quiz data from your system. Please restart the App and try again.\n If the Error persists, please contact the developer")
                }
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
