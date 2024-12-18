//
//  CategoryViewer.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 18.12.24.
//

import SwiftUI
import CoreData

internal struct CategoryViewer: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @State private var allCategories : [Category] = []
    
    private var selectedCategories : Binding<[Category]>
    
    internal init(
        selectedCategories : Binding<[Category]>,
        in allCategories : [Category]
    ) {
        self.allCategories = allCategories
        self.selectedCategories = selectedCategories
    }
    
    var body: some View {
        List {
            ForEach(allCategories) {
                cat in
                SelectableRow(selection: selectedCategories, category: cat)
            }
        }
    }
}

private struct SelectableRow: View {
    
    private var selection : Binding<[Category]>
    
    @State private var isSelected : Bool
    
    private let category : Category
    
    internal init(
        selection: Binding<[Category]>,
        category: Category
    ) {
        self.selection = selection
        self.category = category
        isSelected = selection.wrappedValue.contains(where: { $0 == category })
    }
    
    var body: some View {
        HStack {
            Button {
                isSelected.toggle()
                if selection.wrappedValue.contains(category) {
                    selection.wrappedValue.removeAll(where: { $0 == category })
                } else {
                    selection.wrappedValue.append(category)
                }
            } label: {
                Image(systemName: isSelected ? "checkmark.circle" : "circle")
            }
            .foregroundStyle(.primary)
            Text(category.name!)
        }
    }
}

// TODO: work on preview, currently not working, because sqlite file is not found
//#Preview {
//    @Previewable @State var selectedCategories : [Category] = []
//    var controller : PersistenceController = PersistenceController.preview
//    CategoryViewer(
//        selectedCategories: $selectedCategories,
//        in: try! Storage.fetchCategories(
//            with: controller.container.viewContext)
//    )
//    .environment(\.managedObjectContext, controller.container.viewContext)
//}
