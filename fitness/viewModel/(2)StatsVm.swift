//
//  (2)StatsVm.swift
//  fitness
//
//  Created by Ahmad Hamdy on 02/01/2026.
//

import Foundation


@Observable
class StatsVm {
    private let calendar = Calendar.current
    
    func generateData(for option: ChartOptions) -> [StepModel] {
        let today = Date()
        
        if let days = option.days {
            return (0..<days).map { dayOffset in
                StepModel(
                    date: calendar.date(byAdding: .day, value: -dayOffset, to: today) ?? today,
                    count: Int.random(in: option.stepRange)
                )
            }
        } else if let months = option.months {
            return (0..<months).map { monthOffset in
                StepModel(
                    date: calendar.date(byAdding: .month, value: -monthOffset, to: today) ?? today,
                    count: Int.random(in: option.stepRange)
                )
            }
        } else if option.isYTD {
            let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: today)) ?? today
            let monthsFromStartOfYear = calendar.dateComponents([.month], from: startOfYear, to: today).month ?? 0
            
            return (0...monthsFromStartOfYear).map { monthOffset in
                StepModel(
                    date: calendar.date(byAdding: .month, value: monthOffset, to: startOfYear) ?? today,
                    count: Int.random(in: option.stepRange)
                )
            }
        }
        
        return []
    }
}
