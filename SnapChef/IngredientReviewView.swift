//
//  IngredientReviewView.swift
//  SnapChef
//

import SwiftUI
import PhotosUI

struct IngredientReviewView: View {
    @Binding var selectedPhoto: PhotosPickerItem?
    @Binding var isPresented: Bool
    
    @State private var ingredients: [String] = ["Eggs", "Milk", "Spinach", "Tomato"]
    @State private var newIngredient: String = ""
    @State private var isShowingGeneratedRecipes = false
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Detected Ingredients")) {
                    ForEach(ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                    }
                    .onDelete(perform: deleteIngredient)
                }
                
                Section(header: Text("Add Ingredient")) {
                    HStack {
                        TextField("e.g. Cheese", text: $newIngredient)
                            .onSubmit {
                                addIngredient()
                            }
                        Button(action: addIngredient) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(.tint)
                        }
                        .disabled(newIngredient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
            .listStyle(.insetGrouped)
            
            Button {
                isShowingGeneratedRecipes = true
            } label: {
                Text("Generate Recipes")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 16))
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            .disabled(ingredients.isEmpty)
        }
        .navigationTitle("Review Ingredients")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isShowingGeneratedRecipes) {
            GeneratedRecipesView(isFlowPresented: $isPresented)
        }
    }
    
    private func addIngredient() {
        let trimmed = newIngredient.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty && !ingredients.contains(trimmed) {
            withAnimation {
                ingredients.append(trimmed)
            }
        }
        newIngredient = ""
    }
    
    private func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
}

#Preview {
    NavigationStack {
        IngredientReviewView(selectedPhoto: .constant(nil), isPresented: .constant(true))
    }
}
