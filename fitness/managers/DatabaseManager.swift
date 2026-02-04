//
//  DatabaseManager.swift
//  fitness
//
//  Created by Ahmad Hamdy on 10/01/2026.
//

import Foundation
import FirebaseFirestore

class DatabaseManger {
    
    
    static let shared = DatabaseManger()
    private init () {}
    
    let db = Firestore.firestore()
    // fetch Leaderboard
    
    func fetchLeaderboard () async throws {
        
        let snapshot = try await db.collection("groups").getDocuments()
        
        print(snapshot.documents)
        print(snapshot.documents.first?.data() as Any)
        
    }
    
    // Post (update) Leaderboards for currebt user
    
    
}


