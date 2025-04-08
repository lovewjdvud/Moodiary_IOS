//
//  InsightStatResponseDTO.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

// Models/DTO/InsightStatResponseDTO.swift

import Foundation

struct InsightStatResponseDTO: Codable {
    let date: String           // yyyy-MM-dd
    let emotion: String        // 😊, 😢 등
    let productivity: Int      // 1~5
}

