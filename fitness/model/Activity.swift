//
//  CardsModels.swift
//  fitness
//
//  Created by Ahmad Hamdy on 15/12/2025.
//

import Foundation
import SwiftUI

struct Activity : Identifiable{
    
    let id: Int
    let title: String
    let subTitle: String
    let image: String
    let tintColor: Color
    let amount: Int
}
