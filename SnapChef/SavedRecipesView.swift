//
//  SavedRecipesView.swift
//  SnapChef
//

import SwiftUI
import SwiftData

struct SavedRecipesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Recipe.createdAt, order: .reverse) private var recipes: [Recipe]
    
    var body: some View {
        NavigationStack {
            Group {
                if recipes.isEmpty {
                    ContentUnavailableView {
                        Label("No Saved Recipes", systemImage: "book.closed")
                    } description: {
                        Text("Your generated and saved recipes will appear here.")
                    }
                    .onAppear {
                        seedDummyDataIfNone()
                    }
                } else {
                    List {
                        ForEach(recipes) { recipe in
                            NavigationLink {
                                RecipeDetailView(recipe: recipe)
                            } label: {
                                RecipeRow(recipe: recipe)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Saved Recipes")
        }
    }
    
    private func seedDummyDataIfNone() {
        guard recipes.isEmpty else { return }
        
        let dummyRecipe1 = Recipe(
            name: "Avocado Toast",
            ingredients: ["2 slices sourdough", "1 avocado", "Lemon juice", "Chili flakes"],
            steps: ["Toast the bread.", "Mash the avocado with lemon juice.", "Spread on toast and top with chili flakes."],
            time: "5 min",
            difficulty: "easy",
            createdAt: Date()
        )
        
        let dummyRecipe2 = Recipe(
            name: "Tomato Basil Pasta",
            ingredients: ["8 oz pasta", "1 can diced tomatoes", "1/4 cup olive oil", "Fresh basil", "2 cloves garlic"],
            steps: ["Boil pasta.", "Sauté garlic in olive oil, add tomatoes.", "Simmer for 10 min.", "Toss pasta with sauce and top with basil."],
            time: "20 min",
            difficulty: "medium",
            createdAt: Date().addingTimeInterval(-86400) // Yesterday
        )
        
        modelContext.insert(dummyRecipe1)
        modelContext.insert(dummyRecipe2)
    }
}

struct RecipeRow: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.orange.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                if let imageURL = recipe.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(.rect(cornerRadius: 8))
                        } else if phase.error != nil {
                            Image(systemName: "photo")
                                .foregroundStyle(.orange)
                        } else {
                            ProgressView()
                        }
                    }
                } else {
                    Image(systemName: "fork.knife")
                        .foregroundStyle(.orange)
                }
            }
            
            // Text Details
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack(spacing: 12) {
                    Label(recipe.time, systemImage: "clock")
                    Label(recipe.shortDifficulty, systemImage: "chart.bar")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SavedRecipesView()
        .modelContainer(for: Recipe.self, inMemory: true)
}
