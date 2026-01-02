//
//  StatsModel.swift
//  fitness
//
//  Created by Ahmad Hamdy on 02/01/2026.
//

import Foundation
internal import SwiftUI


struct StepModel: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}



enum ChartOptions: String, CaseIterable {
    case oneWeek = "1W"
    case oneMonth = "1M"
    case threeMonth = "3M"
    case oneYear = "1Y"
    case yearToDate = "YTD"
    
    var days: Int? {
        switch self {
        case .oneWeek: return 7
        case .oneMonth: return 30
        case .threeMonth: return 90
        default: return nil
        }
    }
    
    var months: Int? {
        switch self {
        case .oneYear: return 12
        default: return nil
        }
    }
    
    var isYTD: Bool {
        self == .yearToDate
    }
    
    var chartUnit: Calendar.Component {
        switch self {
        case .oneWeek, .oneMonth: return .day
        case .threeMonth: return .weekOfYear
        case .oneYear, .yearToDate: return .month
        }
    }
    
    var stepRange: ClosedRange<Int> {
        switch self {
        case .oneWeek, .oneMonth, .threeMonth:
            return 2500...12000
        case .oneYear, .yearToDate:
            return 75000...350000
        }
    }
    
    var timeLabel: String {
        switch self {
        case .oneWeek: return "Week"
        case .oneMonth: return "Month"
        case .threeMonth: return "3 Months"
        case .oneYear: return "Year"
        case .yearToDate: return "Year to Date"
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)
                
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        )
    }
}
