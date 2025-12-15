//
//  ContentView.swift
//  fitness
//
//  Created by Ahmad Hamdy on 12/12/2025.
//

import SwiftUI

struct MainScreen: View {
    @State private var selectedTab = "Home"
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Selected state
        appearance.stackedLayoutAppearance.selected.iconColor = .green
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.green
        ]
        
        // Unselected state (optional but recommended)
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray
        ]
        
        // Apply to both standard and scroll edge
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Home()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag("Home")
            
            HistoryData()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Charts")
                }
                .tag("History")
        }
    }
}

#Preview {
    MainScreen()
}



