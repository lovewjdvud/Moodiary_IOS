//
//  InsightStatModel.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

// Models/Domain/InsightStatModel.swift

import Foundation

struct InsightStatModel: Codable,Equatable, Identifiable {
    var id = UUID()
    let date: Date
    let emotion: String
    let productivity: Int
}

