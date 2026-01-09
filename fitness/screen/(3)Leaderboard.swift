//
//  Leaderboard.swift
//  fitness
//
//  Created by Ahmad Hamdy on 06/01/2026.
//

 import SwiftUI


struct LeaderboardUser: Codable, Identifiable {
    
    let id: Int
    let createdAt: String
    let userName: String
    let count: Int
    
}

@Observable
class LeaderboardVm
{
    var mockData = [
        LeaderboardUser(id: 0, createdAt: "", userName: "max", count: 1253),
        LeaderboardUser(id: 2, createdAt: "", userName: "sean", count: 5343),
        LeaderboardUser(id: 3, createdAt: "", userName: "allen", count: 5423),
        LeaderboardUser(id: 4, createdAt: "", userName: "andy", count: 1263),
        LeaderboardUser(id: 5, createdAt: "", userName: "peter", count: 2143),
        LeaderboardUser(id: 6, createdAt: "", userName: "rose", count: 6123),
        
        LeaderboardUser(id: 7, createdAt: "", userName: "hana", count: 4123),
        LeaderboardUser(id: 8, createdAt: "", userName: "sara", count: 8153),
        LeaderboardUser(id: 9, createdAt: "", userName: "jessy", count: 6523),
        LeaderboardUser(id: 10, createdAt: "", userName: "noah", count: 9124),
        LeaderboardUser(id: 11, createdAt: "", userName: "josh", count: 5127),
        LeaderboardUser(id: 12, createdAt: "", userName: "jason", count: 7124),
    ]
    
}

struct Leaderboard: View {
    
    @State var vm = LeaderboardVm()
    @Binding var showTerms : Bool
    
    var body: some View {
        VStack{
            Text("Leaderboard")
                .font(.largeTitle)
                .bold()
            
            HStack{
                
                Text("Name")
                    .bold()
                
                Spacer()
                
                Text("Steps")
                    .bold()
            }
            .padding()
            
            LazyVStack(spacing: 24){
                ForEach(vm.mockData) { person in
                    HStack{
                        
                        Text("\(person.id)")
                        
                        Text(person.userName)
                        
                        Spacer()
                        
                        Text("\(person.count)")
                    }
                }.padding(.horizontal)
            }
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .fullScreenCover(isPresented: $showTerms) {
            Terms()
        }
    }
}

#Preview {
    Leaderboard(showTerms: .constant(false))
}
