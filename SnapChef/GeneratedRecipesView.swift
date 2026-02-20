//
//  GeneratedRecipesView.swift
//  SnapChef
//

import SwiftUI

struct GeneratedRecipesView: View {
    @Binding var isFlowPresented: Bool
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Generating delicious recipes...")
                    .progressViewStyle(.circular)
                    .padding()
            } else {
                List {
                    // Mock recipes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Scrambled Eggs with Spinach")
                            .font(.headline)
                        Text("10 mins • Easy")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tomato Cream Soup")
                            .font(.headline)
                        Text("25 mins • Medium")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
                
                Button("Done") {
                    isFlowPresented = false // Dismiss the entire flow
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .navigationTitle("Your Recipes")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                try? await Task.sleep(for: .seconds(2))
                withAnimation {
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GeneratedRecipesView(isFlowPresented: .constant(true))
    }
}
