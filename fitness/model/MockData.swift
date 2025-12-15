//
//  MockData.swift
//  fitness
//
//  Created by Ahmad Hamdy on 15/12/2025.
//

import Foundation
import SwiftUI

struct MockData {
   static let mockActivity: [Activity] = [
        Activity(id: 1, title: "Today Steps", subTitle: "Goal 10,000", image: "figure.walk", tintColor: .green, amount: 9812),
        Activity(id: 2, title: "Calories", subTitle: "Goal 500", image: "figure.walk", tintColor: .red, amount: 420),
        Activity(id: 3, title: "Calories", subTitle: "Goal 500", image: "flame", tintColor: .purple, amount: 6420),
        Activity(id: 4, title: "Calories", subTitle: "Goal 500", image: "figure.run", tintColor: .blue, amount: 6420)
        
    ]
    
    static let mockWorkouts: [Workout] = [
        Workout(id: UUID(), title: "Running", image: "figure.run",tintColor: .cyan, duration: "51 mins", date: "jan 3", calories: "345"),
        Workout(id: UUID(), title: "Running", image: "figure.run",tintColor: .red, duration: "51 mins", date: "jan 3", calories: "345"),
        Workout(id: UUID(), title: "Running", image: "figure.run",tintColor: .blue, duration: "51 mins", date: "jan 3", calories: "345"),
        Workout(id: UUID(), title: "Running", image: "figure.run",tintColor: .green, duration: "51 mins", date: "jan 3", calories: "345")
    ]
    
}
