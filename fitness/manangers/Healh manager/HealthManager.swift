//
//  HealthManager.swift
//  fitness
//
//  Created by Ahmad Hamdy on 16/12/2025.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        let calender = Calendar.current
        return calender.startOfDay(for: Date())
    }
}


class HealthManager {
    
    static let shared = HealthManager()
   
    let healthStore = HKHealthStore()
    
    private init () {
        
        let calories = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand    = HKCategoryType(.appleStandHour)
        
        let healthTypes: Set = [calories, exercise, stand]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchTodayCaloriesBurned(compilation: @escaping(Result<Double, Error> ) -> Void){
        
        let calories  = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
    }
    
    
}
