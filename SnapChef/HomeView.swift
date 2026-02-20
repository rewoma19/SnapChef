//
//  HomeView.swift
//  SnapChef
//

import SwiftUI
import SwiftData
import PhotosUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settingsArray: [UserSettings]
    
    @State private var mascotManager = MascotManager()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isShowingReview = false
    
    private var userSettings: UserSettings? {
        settingsArray.first
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Top section / Mascot
                VStack(spacing: 16) {
                    Image(systemName: "figure.wave") // Placeholder mascot
                        .font(.system(size: 80))
                        .foregroundStyle(.tint)
                        .padding(32)
                        .background(
                            Circle()
                                .fill(Color.accentColor.opacity(0.1))
                        )
                    
                    Text("\(mascotManager.stage) - Level \(mascotManager.level)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text(greetingText(for: mascotManager.mood))
                        .font(.title.bold())
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Optional: show progress to next level
                    ProgressView(value: mascotManager.progressToNextLevel)
                        .padding(.horizontal, 40)
                        .tint(.accentColor)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 16) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        HStack {
                            Image(systemName: "camera.viewfinder")
                            Text("Scan Fridge")
                        }
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 16))
                    }
                    .onChange(of: selectedPhoto) { _, newItem in
                        if newItem != nil {
                            mascotManager.recordAction(.scanCompleted)
                            isShowingReview = true
                        }
                    }
                    
                    Button {
                        // TODO: Implement view last scan
                    } label: {
                        Text("View last scan")
                            .font(.subheadline.bold())
                            .foregroundStyle(.tint)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .navigationTitle("Home")
            .navigationDestination(isPresented: $isShowingReview) {
                IngredientReviewView(selectedPhoto: $selectedPhoto, isPresented: $isShowingReview)
            }
            .onAppear {
                setupMascotManager()
            }
        }
    }
    
    private func setupMascotManager() {
        let settings: UserSettings
        if let existingSettings = userSettings {
            settings = existingSettings
        } else {
            // First time logic: create default user settings
            settings = UserSettings()
            modelContext.insert(settings)
        }
        
        mascotManager.setup(modelContext: modelContext, userSettings: settings)
        mascotManager.recordAction(.appOpened)
    }
    
    private func greetingText(for mood: MascotMood) -> String {
        switch mood {
        case .curious:
            return "Show me your fridge 👀"
        case .happy:
            return "Let's cook something together!"
        case .excited:
            return "Just leveled up!"
        case .sleepy:
            return "I missed your cooking..."
        case .proud:
            return "Look at what we made!"
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [Recipe.self, IngredientScan.self, UserSettings.self], inMemory: true)
}
