//
//  RecipeDetailView.swift
//  SnapChef
//

import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MascotManager.self) private var mascotManager
    
    @Bindable var recipe: Recipe
    
    // For this version, assume we're toggling a "saved" state, though all recipes in the list might already be saved.
    // If we want to allow un-saving, we can delete from context.
    // For now, let's just use a simple state to show a "Saved!" confirmation
    @State private var hasJustSaved = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Hero Image Placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.orange.opacity(0.2))
                        .aspectRatio(4/3, contentMode: .fit)
                    
                    if let imageURL = recipe.imageURL, let url = URL(string: imageURL) {
                        AsyncImage(url: url) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(.rect(cornerRadius: 16))
                            } else if phase.error != nil {
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundStyle(.orange)
                            } else {
                                ProgressView()
                            }
                        }
                    } else {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 48))
                            .foregroundStyle(.orange.opacity(0.8))
                    }
                }
                .padding(.horizontal)
                
                // Details Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.name)
                        .font(.title)
                        .bold()
                    
                    HStack(spacing: 16) {
                        Label(recipe.time, systemImage: "clock")
                        Label(recipe.shortDifficulty, systemImage: "chart.bar")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                
                // Ingredients
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ingredients")
                        .font(.title3)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            HStack(alignment: .top) {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 6))
                                    .padding(.top, 6)
                                    .foregroundStyle(.orange)
                                Text(ingredient)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Steps
                VStack(alignment: .leading, spacing: 12) {
                    Text("Steps")
                        .font(.title3)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(recipe.steps.enumerated().map({ $0 }), id: \.element) { index, step in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(width: 28, height: 28)
                                    .background(Color.orange)
                                    .clipShape(.circle)
                                
                                Text(step)
                                    .padding(.top, 4)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button {
                        saveRecipe()
                    } label: {
                        Label(hasJustSaved ? "Saved!" : "Save Recipe", systemImage: hasJustSaved ? "checkmark" : "bookmark")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(hasJustSaved ? Color.green : Color.orange)
                            .foregroundStyle(.white)
                            .clipShape(.rect(cornerRadius: 12))
                    }
                    .disabled(hasJustSaved)
                    
                    Button {
                        // Action for Generate Share Card
                    } label: {
                        Label("Generate Share Card", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange.opacity(0.2))
                            .foregroundStyle(.orange)
                            .clipShape(.rect(cornerRadius: 12))
                    }
                }
                .padding()
                .padding(.bottom, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Re-eval mood or streaks on view open depending on logic
            mascotManager.recordAction(.recipeOpened)
        }
    }
    
    private func saveRecipe() {
        // Since we got this reference, it might already be in context, but we trigger the mascot logic.
        mascotManager.recordAction(.recipeSaved)
        hasJustSaved = true
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: Recipe(
            name: "Spicy Garlic Noodles",
            ingredients: [
                "2 packs ramen noodles",
                "4 cloves garlic, minced",
                "2 tbsp soy sauce",
                "1 tbsp chili oil",
                "1 green onion, chopped"
            ],
            steps: [
                "Boil the noodles according to package instructions.",
                "In a pan, sauté the minced garlic in oil until fragrant.",
                "Add soy sauce and chili oil to the pan.",
                "Toss the cooked noodles in the sauce.",
                "Garnish with chopped green onions."
            ],
            time: "15 min",
            difficulty: "easy"
        ))
        .environment(MascotManager())
    }
}
