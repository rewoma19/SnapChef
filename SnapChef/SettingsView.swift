//
//  SettingsView.swift
//  SnapChef
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Preferences") {
                    Text("Dietary Preferences")
                    Text("Theme Settings")
                }
                
                Section("About") {
                    Text("Version 1.0.0")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
