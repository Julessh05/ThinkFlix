//
//  Welcome.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 15.12.24.
//

import SwiftUI

struct Welcome: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var gameConfigShown : Bool = false
    
    @State private var allCategories : [CategoryJSON] = []
    
    
    var body: some View {
        VStack {
            Button {
                gameConfigShown.toggle()
            } label: {
                Label("New Game", systemImage: "play")
                    .foregroundStyle(.white)
                    .frame(width: 210, height: 70)
                    .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
                    .backgroundStyle(colorScheme == .dark ? .gray : .blue)
            }
            .sheet(isPresented: $gameConfigShown) {
                GameConfigView()
            }
            NavigationLink {
                CategoryViewer(allCategories)
            } label: {
                Label("Categories", systemImage: "pencil.and.list.clipboard")
                    .foregroundStyle(.white)
                    .frame(width: 210, height: 70)
                    .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
                    .backgroundStyle(colorScheme == .dark ? .gray : .blue)
            }
//            NavigationLink {
//                StatisticsView()
//            } label: {
//                Label("Statistics", systemImage: "chart.bar")
//                    .foregroundStyle(.white)
//                    .frame(width: 210, height: 70)
//                    .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
//                    .backgroundStyle(colorScheme == .dark ? .gray : .blue)
//            }
        }
        .navigationTitle("ThinkFlix")
        .onAppear {
            do {
                allCategories = try Storage.loadCategoriesFromJSON()
                //                allCategories = try Storage.fetchCategories(with: context)
            } catch {
                print("Error")
                //                    errFetchingCategories.toggle()
            }
        }
    }
}

#Preview {
    NavigationStack {
        Welcome()
    }
}
