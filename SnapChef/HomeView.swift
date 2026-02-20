//
//  HomeView.swift
//  SnapChef
//

import SwiftUI

@Observable
@MainActor
class MascotViewModel {
    var level: Int
    var stage: String
    var mood: String
    
    init(level: Int = 1, stage: String = "Baby Chef", mood: String = "Curious") {
        self.level = level
        self.stage = stage
        self.mood = mood
    }
}

struct HomeView: View {
    @State private var mascot = MascotViewModel()
    
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
                    
                    Text("\(mascot.stage) - Level \(mascot.level)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text(greetingText(for: mascot.mood))
                        .font(.title.bold())
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 16) {
                    Button {
                        // Placeholder for scan action
                    } label: {
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
                    
                    Button {
                        // Placeholder for view last scan action
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
        }
    }
    
    private func greetingText(for mood: String) -> String {
        switch mood {
        case "Curious":
            return "Show me your fridge 👀"
        case "Happy":
            return "Let's cook something together!"
        case "Excited":
            return "Just leveled up!"
        case "Sleepy":
            return "I missed your cooking..."
        default:
            return "Let's cook something!"
        }
    }
}

#Preview {
    HomeView()
}
