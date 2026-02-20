//
//  SavedRecipesView.swift
//  SnapChef
//

import SwiftUI

struct SavedRecipesView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView {
                Label("No Saved Recipes", systemImage: "book.closed")
            } description: {
                Text("Your generated and saved recipes will appear here.")
            }
            .navigationTitle("Saved Recipes")
        }
    }
}

#Preview {
    SavedRecipesView()
}
