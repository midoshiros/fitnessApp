//  HealthManager.swift
//  fitness
//
//  Created by Ahmad Hamdy on 16/12/2025.


import Foundation
import HealthKit
internal import SwiftUI

import Foundation

extension Date {

    // Start of today
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }

    // Start of current week (locale-aware)
    static var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return calendar.date(from: components) ?? Date()
    }

    // Month start & end
    func monthStartAndEnd() -> (start: Date, end: Date) {
        let calendar = Calendar.current

        let startComponents = calendar.dateComponents([.year, .month], from: self)
        let start = calendar.date(from: startComponents) ?? self

        let end = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: start) ?? self

        return (start, end)
    }
    
    
    func formatWorkoutDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
    
}


extension Double {

    private static let integerFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    func formattedNumberString() -> String {
        Self.integerFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
}

extension TimeInterval {

    var minutesString: String {
        let minutes = Int(self) / 60
        return "\(minutes) min"
    }
}



class HealthManager {
    
    static let shared = HealthManager()
    
    let healthStore = HKHealthStore()
    
    private init () {}
    
    
    func requestHealtKitAccess() async throws {
        
        let calories = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand    = HKCategoryType(.appleStandHour)
        let steps    = HKQuantityType(.stepCount)
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
            
            let standCount = samples.filter({$0.value == 1 }).count
            
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
            let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
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
        
        
        
        
        
        // MARK: Recent Workouts
        func fetchWorkoutsForMonth(month: Date, completion: @escaping(Result<[Workout], Error>) -> Void){
            let workouts = HKSampleType.workoutType()
            let(startDate, endDate) = month.monthStartAndEnd()
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
            
            let sortDescript = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            
            let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors:[sortDescript]) {_,result,error in
                guard let workouts = result as? [HKWorkout] , error == nil else {
                    completion(.failure(URLError(.badURL)) )
                    return
                }
                
                let workoutsArray = workouts.map {
                    Workout(
                        id: UUID(),
                        title: $0.workoutActivityType.name,
                        image: $0.workoutActivityType.image,
                        tintColor: $0.workoutActivityType.color,
                        duration: $0.duration.minutesString,
                        date: $0.startDate.formatWorkoutDate(),
                        calories: ($0.totalEnergyBurned?
                            .doubleValue(for: .kilocalorie())
                            .formattedNumberString() ?? "-"  ) + "Kcal" ) }
                completion(.success(workoutsArray))
            }
            healthStore.execute(query)
        }
        
    }

