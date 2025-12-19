//
//  ProgressCircle.swift
//  fitness
//
//  Created by Ahmad Hamdy on 12/12/2025.
//

internal import SwiftUI

struct ProgressCircle: View {
    @Binding var progress: Int
    var goal: Int
    var color: Color
    private let width: CGFloat = 20
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(color.opacity(0.3), lineWidth: 20)
            
            Circle()
                .trim(from: 0, to: CGFloat(progress) / CGFloat(goal))
                .stroke(color, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .shadow(radius: 5)
                
        }
    }
}

#Preview {
    ProgressCircle(
        progress: .constant(100), goal: 200, color: .red
        
    )
}
