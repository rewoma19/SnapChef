//
//  HomeView.swift
//  SnapChef
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                // Placeholder for mascot and scan button
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 60))
                    .foregroundStyle(.tint)
                    .padding()
                
                Text("Scan Fridge")
                    .font(.title2.bold())
                
                Text("Let's cook something together!")
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}
