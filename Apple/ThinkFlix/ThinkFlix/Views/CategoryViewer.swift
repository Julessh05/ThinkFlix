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
    
//    @State private var allCategories : [Category] = []
    @State private var allCategories : [CategoryJSON] = []
    
//    private var selectedCategories : Binding<[Category]>
    private var selectedCategories : Binding<[CategoryJSON]>
    
    private var edit : Bool
    
    internal init(
        selectedCategories : Binding<[CategoryJSON]>,
        in allCategories : [CategoryJSON]
    ) {
        self.edit = true
        self.allCategories = allCategories
        self.selectedCategories = selectedCategories
    }
    
    internal init(_ allCategories : [CategoryJSON]) {
        self.edit = false
        self.allCategories = allCategories
        self.selectedCategories = .constant([])
    }
    
    
    
    var body: some View {
        List {
            ForEach(allCategories, id: \CategoryJSON.id) {
                category in
                Section(category.name) {
                    if let subs = category.subcategories {
                        ForEach(subs, id: \CategoryJSON.name) {
                            subcategory in
                            if edit {
                                SelectableRow(selection: selectedCategories, category: subcategory)
                            } else {
                                Text(subcategory.name)
                            }
                        }
                    } else {
                        if edit {
                            SelectableRow(selection: selectedCategories, category: category)
                        } else {
                            Text(category.name)
                        }
                    }
                }
            }
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.automatic)
    }
}

private struct SelectableRow: View {
    
//    private var selection : Binding<[Category]>
    private var selection : Binding<[CategoryJSON]>
    
    @State private var isSelected : Bool
    
//    private let category : Category
    private let category : CategoryJSON
    
    internal init(
        selection: Binding<[CategoryJSON]>,
        category: CategoryJSON
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
            Text(category.name)
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
