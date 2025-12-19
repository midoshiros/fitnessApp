//
//  Card.swift
//  fitness
//
//  Created by Ahmad Hamdy on 14/12/2025.
//

internal import SwiftUI


struct ActivtyCard: View {
    
    let activity: Activity

    var body: some View {
        ZStack{
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            VStack{
                HStack(alignment: .top){
                   
                    VStack(alignment: .leading,spacing: 8){
                        Text(activity.title)
                        
                        Text(activity.subTitle)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: activity.image)
                        .foregroundStyle(activity.tintColor)
                }
                
                Text("\(activity.amount)" )
                    .font(.title)
                    .bold()
                    .padding()
                
            }
            .padding()
        }
    }
}

#Preview {
    ActivtyCard(activity: Activity(id: 0, title: "Today Stips", subTitle: "Goal 10,000", image: "figure.walk", tintColor: .green, amount: "9812"))
}
