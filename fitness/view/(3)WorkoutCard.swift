//
//  WorkoutCard.swift
//  fitness
//
//  Created by Ahmad Hamdy on 15/12/2025.
//

import SwiftUI



struct WorkoutCard: View {
    var workout: Workout
    
    var body: some View {
        HStack{
            Image(systemName: workout.image)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundStyle(workout.tintColor)
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
            
            VStack(spacing: 15) {
                HStack{
                    Text(workout.title)
                        .font(.title3)
                        .bold()
                    Spacer()
                    
                    Text(workout.duration)
                }
                
                HStack{
                    Text(workout.date)
                   
                    Spacer()
                    Text(workout.calories)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    WorkoutCard(workout: Workout(id: UUID(), title: "Running", image: "figure.run",tintColor: .cyan, duration: "51 mins", date: "jan 3", calories: "345"))
}
