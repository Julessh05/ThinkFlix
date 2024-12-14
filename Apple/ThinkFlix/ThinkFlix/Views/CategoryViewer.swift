//
//  CategoryViewer.swift
//  ThinkFlix
//
//  Created by Julian Schumacher on 14.12.24.
//

import SwiftUI

struct CategoryViewer: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

private struct SelectableRow: View {
    
    internal var selection : Binding<[String]>
    
    @State private var isSelected : Bool
    
    internal let category : String
    
    internal init(
        selection: Binding<[String]>,
        category: String
    ) {
        self.selection = selection
        self.category = category
        isSelected = !selection.wrappedValue.contains(where: { $0 == category })
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
            Text(category)
        }
    }
}

#Preview {
    CategoryViewer()
}
