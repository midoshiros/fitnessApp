//
//  ContentView.swift
//  fitness
//
//  Created by Ahmad Hamdy on 12/12/2025.
//

import SwiftUI

struct MainScreen: View {
    @State private var selectedTab = "Home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Home()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag("Home")
            
            chart()
                .tabItem {
                    Label("Charts", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag("History")
        
            Leaderboard()
                .tabItem {
                    Label("Leaderboard", systemImage: "list.bullet")
                }
                .tag("Leaderboard")
        
            
        }
        .tint(.green)
    }
}

#Preview {
    MainScreen()
}
