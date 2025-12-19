//  HealthManager.swift
//  fitness
//
//  Created by Ahmad Hamdy on 16/12/2025.


import Foundation
import HealthKit
internal import SwiftUI

extension Date {
    static var startOfDay: Date {
        let calender = Calendar.current
        return calender.startOfDay(for: Date())
    }
}

extension Date {
    static var startOfweek: Date {
        let calender = Calendar.current
        var components = calender.dateComponents([.yearForWeekOfYear, .weekOfYear ], from: Date())
        components.weekday = 2
        return calender.date(from: components) ?? Date()
    }
}

extension Double {
    func formattedNumberString() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}

class HealthManager {
    
    static let shared = HealthManager()
   
    let healthStore = HKHealthStore()
    
    private init () {
        
        Task {
            do {
                try await requestHealtKitAccess()
            } catch{
                print(error.localizedDescription)
            }
        }
    }
    
    
    func requestHealtKitAccess() async throws {
        
        let calories = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand    = HKCategoryType(.appleStandHour)
        let steps   = HKQuantityType(.stepCount)
        let workouts = HKSampleType.workoutType()
        
        let healthTypes: Set = [calories, exercise, stand, steps, workouts]
        try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
    }
    
    
    func fetchTodayCaloriesBurned(completion: @escaping(Result<Double, Error> ) -> Void){
        
        let calories  = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil  else{completion(.failure(URLError(.badURL) ) )
                return
            }
            let calorieCount = quantity.doubleValue(for: .kilocalorie())
            completion(.success(calorieCount))
        }
        healthStore.execute(query)
        
    }
    
    
    func fetchTodayExerciseTime(completion: @escaping(Result<Double, Error> ) -> Void){
        
        let exercise  = HKQuantityType(.appleExerciseTime)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: exercise, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil  else{completion(.failure(URLError(.badURL)) )
                return
            }
            let exerciseTime = quantity.doubleValue(for: .minute())
            completion(.success(exerciseTime))
        }
        healthStore.execute(query)
        
    }
    
    
    func fetchTodayStandHour(completion: @escaping(Result<Int, Error> ) -> Void){
        
        let stand     = HKCategoryType(.appleStandHour)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: stand, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors:nil) { _,result,error in
            guard let samples = result as? [HKCategorySample] , error == nil  else {
                completion(.failure(URLError(.badURL)) )
                return }
            print(samples)
            print(samples.map({ $0.value }))
            let standCount = samples.filter({$0.value == 0 }).count
            
            completion(.success(standCount))
        }
        
        
        healthStore.execute(query)
        
    }
    
    // MARK: Fitness Activity
    func fetchTodaySteps(completion: @escaping(Result<Activity, Error>) -> Void) {
        
        let steps   = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil  else{completion(.failure(URLError(.badURL) ) )
                return
            }
            let steps = quantity.doubleValue(for: .count())
            let activity = Activity(id: 7, title: "Today Steps", subTitle: "Goal: 800", image: "figure.walk", tintColor: .red, amount: steps.formattedNumberString())
            completion(.success(activity))
        }
        healthStore.execute(query)
    }
    
    func fetchCurrentWeekWorkoutStats(completion: @escaping(Result<[Activity], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: .startOfweek, end: Date())
        let quiry = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self]_, result, error in
            guard let workouts = result as? [HKWorkout] , let self = self, error == nil  else {
                completion(.failure(URLError(.badURL)) )
                return
            }
            
            var runningCount = 0
            var strengthCount = 0
            var fotballCount = 0
            var basketballCount = 0
            var stairsCount = 0
            var kickboxingCount = 0
            
            for workout in workouts {
                let duration = Int(workout.duration) / 60
                if workout.workoutActivityType == .running {
                    runningCount += duration
                } else if workout.workoutActivityType == .traditionalStrengthTraining {
                    strengthCount += duration
                }else if workout.workoutActivityType == .soccer {
                    fotballCount += duration
                }else if workout.workoutActivityType == .baseball {
                    basketballCount += duration
                }else if workout.workoutActivityType == .stairClimbing {
                    stairsCount += duration
                }else if workout.workoutActivityType == .kickboxing {
                    kickboxingCount += duration
                }
                
            }
            
            completion(.success(generateActivitiesFromDuration(running: runningCount, strength: strengthCount, soccer: fotballCount, basketball: basketballCount, stairs: stairsCount, kickboxing: kickboxingCount)))
        }
        healthStore.execute(quiry)
    }
    
    func generateActivitiesFromDuration(running: Int, strength: Int, soccer: Int, basketball: Int, stairs: Int, kickboxing: Int) -> [Activity] {
        return [
            Activity(id: 8,  title: "Running", subTitle: "This week", image: "figure.run", tintColor: .red, amount: "\(running) mins"),
            Activity(id: 9,  title: "strength", subTitle: "This week", image: "dumbbell", tintColor: .blue, amount: "\(strength) mins"),
            Activity(id: 10, title: "soccer", subTitle: "This week", image: "figure.soccer", tintColor: .green, amount: "\(soccer) mins"),
            Activity(id: 11, title: "basketball", subTitle: "This week", image: "figure.basketball", tintColor: .yellow, amount: "\(basketball) mins"),
            Activity(id: 12, title: "stairs", subTitle: "This week", image: "figure.stairs", tintColor: .indigo, amount: "\(stairs) mins"),
            Activity(id: 13, title: "kickboxing", subTitle: "This week", image: "figure.kickboxing", tintColor: .black, amount: "\(kickboxing) mins"),
        ]
    }
    
}



