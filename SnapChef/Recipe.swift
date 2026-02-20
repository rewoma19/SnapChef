//
//  Recipe.swift
//  SnapChef
//

import Foundation
import SwiftData

@Model
final class Recipe {
    var id: UUID = UUID()
    var name: String = ""
    var ingredients: [String] = []
    var steps: [String] = []
    var time: String = ""
    var difficulty: String = ""
    var createdAt: Date = Date()
    var imageURL: String?
    var templateStyle: String?
    var mascotBoost: Int = 0
    
    init(
        id: UUID = UUID(),
        name: String = "",
        ingredients: [String] = [],
        steps: [String] = [],
        time: String = "",
        difficulty: String = "",
        createdAt: Date = Date(),
        imageURL: String? = nil,
        templateStyle: String? = nil,
        mascotBoost: Int = 0
    ) {
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.steps = steps
        self.time = time
        self.difficulty = difficulty
        self.createdAt = createdAt
        self.imageURL = imageURL
        self.templateStyle = templateStyle
        self.mascotBoost = mascotBoost
    }
    
    // Helper computed properties
    var formattedDate: String {
        createdAt.formatted(date: .abbreviated, time: .omitted)
    }
    
    var shortDifficulty: String {
        guard !difficulty.isEmpty else { return "" }
        return difficulty.prefix(1).uppercased() + difficulty.dropFirst()
    }
}
