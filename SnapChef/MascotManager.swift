//
//  MascotManager.swift
//  SnapChef
//

import SwiftUI
import SwiftData

/// Represents all user actions that interact with Mascot XP/Mood
enum MascotAction {
    case scanCompleted
    case recipeSaved
    case recipeOpened
    case shareCardGenerated
    case shareCardExported
    case appOpened // Triggered when app opens for streak/mood checking
}

/// The visual mood of the Mascot
enum MascotMood: String {
    case excited = "Excited"
    case proud = "Proud"
    case sleepy = "Sleepy"
    case curious = "Curious" // For when app is opened but no scan in this session
    case happy = "Happy"     // Default for active session
}

/// Manages Mascot XP, Levels, Mood, and Streaks
@Observable
@MainActor
class MascotManager {
    var mood: MascotMood = .happy
    
    // Dependencies
    private var modelContext: ModelContext?
    private var userSettings: UserSettings?
    
    init() {}
    
    /// Binds the manager to SwiftData context from UI. Call this from .onAppear.
    func setup(modelContext: ModelContext, userSettings: UserSettings) {
        self.modelContext = modelContext
        self.userSettings = userSettings
    }
    
    // MARK: - Computed Properties for UI
    
    var level: Int { userSettings?.mascotLevel ?? 1 }
    var xp: Int { userSettings?.mascotXP ?? 0 }
    
    var stage: String {
        userSettings?.mascotStage ?? "Baby Chef"
    }
    
    var progressToNextLevel: Double {
        userSettings?.xpProgressToNextLevel ?? 0.0
    }
    
    // MARK: - Actions
    
    /// Translates actions into XP gains, streaks, and mood changes
    func recordAction(_ action: MascotAction) {
        guard let settings = userSettings else { return }
        
        var xpGained = 0
        var shouldHandleActivity = true
        
        // 1. Setup specific XP rewards & initial Mood for action
        switch action {
        case .scanCompleted:
            xpGained = 5
            mood = .happy
        case .recipeSaved:
            xpGained = 10
            mood = .proud
        case .recipeOpened:
            xpGained = 5
        case .shareCardGenerated:
            xpGained = 15
        case .shareCardExported:
            xpGained = 20
            mood = .proud
        case .appOpened:
            shouldHandleActivity = false
            updateMoodForAppOpen(settings: settings)
        }
        
        // 2. Add Activity XP if applicable (Streaks & Level Ups)
        if shouldHandleActivity {
            // Processing activity updates streak, potentially giving XP and changing mood to .excited
            handleActivity(settings: settings)
            
            if xpGained > 0 {
                // Add XP updates level, potentially changing mood to .excited
                addXP(xpGained, to: settings)
            }
        }
    }
    
    // MARK: - Logic
    
    private func updateMoodForAppOpen(settings: UserSettings) {
        if let lastDate = settings.lastActivityDate {
            let daysSinceActivity = Calendar.current.dateComponents([.day], from: lastDate, to: Date()).day ?? 0
            if daysSinceActivity >= 3 {
                mood = .sleepy
                return
            }
        }
        
        // App opened, defaults to curious until they perform a scan
        mood = .curious
    }
    
    private func handleActivity(settings: UserSettings) {
        let calendar = Calendar.current
        let now = Date()
        
        if let lastDate = settings.lastActivityDate {
            if calendar.isDateInToday(lastDate) {
                // Active already today, no streak change
            } else if calendar.isDateInYesterday(lastDate) {
                // Active yesterday, increment streak
                settings.streakCount += 1
                
                // Reward streaks
                if settings.streakCount == 7 {
                    addXP(50, to: settings)
                    mood = .excited
                } else if settings.streakCount == 3 {
                    addXP(25, to: settings)
                    mood = .excited
                }
            } else {
                // Missed a day(s)
                settings.streakCount = 1
            }
        } else {
            // First time action
            settings.streakCount = 1
        }
        
        settings.lastActivityDate = now
    }
    
    private func addXP(_ amount: Int, to settings: UserSettings) {
        settings.mascotXP += amount
        checkLevelUp(settings: settings)
    }
    
    private func checkLevelUp(settings: UserSettings) {
        let startingLevel = settings.mascotLevel
        var currentLevel = startingLevel
        
        // Keep checking if they leveled up multiple times
        while settings.mascotXP >= xpRequiredForLevel(currentLevel + 1) {
            currentLevel += 1
        }
        
        if currentLevel > startingLevel {
            settings.mascotLevel = currentLevel
            mood = .excited
        }
    }
    
    private func xpRequiredForLevel(_ targetLevel: Int) -> Int {
        // Thresholds from PRD
        let thresholds: [Int: Int] = [
            1: 0,
            2: 10,
            3: 25,
            4: 45,
            5: 70,
            6: 100,
            7: 135,
            8: 175
        ]
        
        if targetLevel <= 8 {
            return thresholds[targetLevel] ?? 0
        } else {
            let baseXP = thresholds[8] ?? 175
            let extraLevels = targetLevel - 8
            return baseXP + (extraLevels * 40)
        }
    }
}
