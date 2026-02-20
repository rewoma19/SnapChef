//
//  UserSettings.swift
//  SnapChef
//

import Foundation
import SwiftData

@Model
final class UserSettings {
    var dietPreference: String?
    var mascotLevel: Int = 1
    var mascotXP: Int = 0
    var lastActivityDate: Date?
    var streakCount: Int = 0
    var preferredTemplate: String = "minimal"
    
    init(
        dietPreference: String? = nil,
        mascotLevel: Int = 1,
        mascotXP: Int = 0,
        lastActivityDate: Date? = nil,
        streakCount: Int = 0,
        preferredTemplate: String = "minimal"
    ) {
        self.dietPreference = dietPreference
        self.mascotLevel = mascotLevel
        self.mascotXP = mascotXP
        self.lastActivityDate = lastActivityDate
        self.streakCount = streakCount
        self.preferredTemplate = preferredTemplate
    }
    
    // Helper computed property for UI
    var mascotStage: String {
        switch mascotLevel {
        case 1...3: return "Baby Chef"
        case 4...7: return "Apprentice Chef"
        default: return "Master Chef"
        }
    }
    
    // Percentage to next level (approximate math based on PRD thresholds)
    var xpProgressToNextLevel: Double {
        let thresholds = [0, 10, 25, 45, 70, 100, 135, 175]
        let currentLevelIndex = min(mascotLevel - 1, thresholds.count - 1)
        
        let currentFloor = thresholds[currentLevelIndex]
        let nextGoal = (mascotLevel < thresholds.count) ? thresholds[currentLevelIndex + 1] : (currentFloor + 40)
        
        guard nextGoal > currentFloor else { return 1.0 }
        let progress = Double(mascotXP - currentFloor) / Double(nextGoal - currentFloor)
        return min(max(progress, 0.0), 1.0)
    }
}
