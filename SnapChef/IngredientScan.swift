//
//  IngredientScan.swift
//  SnapChef
//

import Foundation
import SwiftData

@Model
final class IngredientScan {
    var id: UUID = UUID()
    var date: Date = Date()
    var ingredients: [String] = []
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        ingredients: [String] = []
    ) {
        self.id = id
        self.date = date
        self.ingredients = ingredients
    }
    
    // Helper computed property
    var formattedDate: String {
        date.formatted(date: .abbreviated, time: .omitted)
    }
}
