//
//  Home.swift
//  fitness
//
//  Created by Ahmad Hamdy on 12/12/2025.
//

import SwiftUI

struct Home: View {
    @State var vm = HomeVm()
   
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){
                    Text("Welcome")
                        .font(.largeTitle)
                        .padding()
                    
                    HStack( ){
                        
                        Spacer()
                        
                        VStack(alignment: .leading){
                            VStack(alignment: .leading, spacing: 8){
                                Text("Calories")
                                    .bold()
                                    .font(.callout)
                                    .foregroundColor(.red)
                                
                                Text("\(vm.calories)")
                                    .bold()
                            }
                            .padding(.bottom, 20)
                            
                            VStack(alignment: .leading, spacing: 8){
                                Text("Active")
                                    .bold()
                                    .font(.callout)
                                    .foregroundColor(.green)
                                
                                Text("\(vm.active)")
                                    .bold()
                            }
                            .padding(.bottom, 20)
                            
                            VStack(alignment: .leading, spacing: 8){
                                Text("Stand")
                                    .bold()
                                    .font(.callout)
                                    .foregroundColor(.blue)
                                
                                Text("\(vm.stand)")
                                    .bold()
                            }
                            
                        }
                        
                        Spacer()
                        
                        ZStack{
                            ProgressCircle(progress: $vm.calories, goal: 400, color: .red)
                            
                            ProgressCircle(progress: $vm.active, goal: 60, color: .green)
                                .padding(.all, 20)
                            ProgressCircle(progress: $vm.stand, goal: 12, color: .blue)
                                .padding(.all, 40)
                        }
                        .padding()
                        Spacer()
                        
                        
                        
                    }
                    .padding()
                    
                    
                    HStack{
                        Text("Fitness Activity")
                            .font(.title2)
                        
                        Spacer()
                        
                        Button{
                            //
                        }label: {
                            Text("Show More")
                                .padding(.all, 10)
                                .foregroundStyle(Color(.white))
                                .background(.blue)
                                .clipShape(.capsule)
                            
                            
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    LazyVGrid( columns: Array(repeating: GridItem(spacing: 20), count: 2)  ){
                        ForEach(MockData.mockActivity) { activity in
                            ActivtyCard(activity: activity)
                        }
                    }
                    .padding()
                    
                    HStack{
                        Text("Fitness Activity")
                            .font(.title2)
                        
                        Spacer()
                        
                        NavigationLink {
                            EmptyView()
                        }label: {
                            Text("Show More")
                                .padding(.all, 10)
                                .foregroundStyle(Color(.white))
                                .background(.blue)
                                .clipShape(.capsule)
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    LazyVGrid( columns: Array(repeating: GridItem(spacing: 20), count: 1)  ){
                        ForEach(MockData.mockWorkouts) { workout in
                            WorkoutCard(workout: workout)
                        }
                    }
                    .padding(.top)
                    
                }
            }
        }
    }
}

#Preview {
    Home()
}
