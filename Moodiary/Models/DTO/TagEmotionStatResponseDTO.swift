//
//  TagEmotionStatResponseDTO.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//


import Foundation

struct TagEmotionStatResponseDTO: Codable {
    let tag: String
    let emotionCounts: [String: Int]  // 예: ["😊": 3, "😢": 2]
}

