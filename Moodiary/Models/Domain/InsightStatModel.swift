//
//  InsightStatModel.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

// Models/Domain/InsightStatModel.swift

import Foundation

struct InsightStatModel: Equatable ,Codable{
    let date: String
    let overallMoodScore: Double
    let happinessMoodScore: Double
    let sadnessMoodScore: Double
    let angerMoodScore: Double
    let anxietyMoodScore: Double
    let dominantMoodLabels: [String]
    // 아마도 다른 필수 속성이 더 있을 수 있습니다
}
