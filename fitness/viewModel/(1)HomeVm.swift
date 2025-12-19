import Foundation
import Observation
internal import SwiftUI

@MainActor
@Observable
class HomeVm {
    
    let healthManager = HealthManager.shared
    
    var calories: Int = 120
    var exercise: Int = 50
    var stand: Int = 8
    var activities = [Activity]()
    
    init() {
        Task {
            do {
                try await healthManager.requestHealtKitAccess()
                fetchTodayCalories()
                fetchTodayExerciseTime()
                fetchTodayStandHour()
                fetchCurrentWeekActivites()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //
    func fetchTodayCalories() {
        healthManager.fetchTodayCaloriesBurned { result in
            switch result {
            case .success(let calories):
                self.calories = Int(calories)
                let activity = Activity(id: 8, title: "Calories burned", subTitle: "Goal: 800", image: "flame", tintColor: .red, amount: calories.formattedNumberString() )
                self.activities.append(activity)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //
    func fetchTodayExerciseTime() {
        healthManager.fetchTodayExerciseTime { result in
            switch result {
            case .success(let exercise):
                self.exercise = Int(exercise)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //
    func fetchTodayStandHour() {
        healthManager.fetchTodayStandHour { result in
            switch result {
            case .success(let hours):
                self.stand = Int(hours)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: Fitness Activity
    func fetchTodaySteps(){
        healthManager.fetchTodaySteps{ result in
            switch result {
            case .success(let activity):
                self.activities.append(activity)
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func fetchCurrentWeekActivites(){
        healthManager.fetchCurrentWeekWorkoutStats{ result in
            switch result {
            case .success(let activities):
                self.activities.append(contentsOf:activities)
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            
        }
    }
}


