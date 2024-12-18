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
    
    private var persistence : PersistenceController = PersistenceController.shared
    
    @State private var errLoadingDataShown : Bool = false

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .onAppear {
                    do {
                        try Storage.checkDatabases(with: persistence.container.viewContext)
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
