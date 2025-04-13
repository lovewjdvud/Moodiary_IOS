//
//  TagEmotionStatModel.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//


import Foundation

struct TagEmotionStatModel: Equatable,Codable, Identifiable, Hashable {
    let id: Int
    let tag: String?
    let emotionCounts: [String: Int]?
    
    var happinessPercent: Double {
        return calculatePercent(for: "happiness")
    }
    
    var sadnessPercent: Double {
        return calculatePercent(for: "sadness")
    }
    
    var angerPercent: Double {
        return calculatePercent(for: "anger")
    }
    
    var anxietyPercent: Double {
        return calculatePercent(for: "anxiety")
    }
    
    private func calculatePercent(for emotion: String) -> Double {
        guard let counts = emotionCounts, let total = counts.values.reduce(0, +) as Int?, total > 0 else {
            return 0.0
        }
        return (Double(counts[emotion] ?? 0) / Double(total)) * 100.0
    }
}
//
//extension TagEmotionStatModel {
//    init(dto: TagEmotionStatResponseDTO) {
//        self.tag = dto.tag
//        self.emotionCounts = dto.emotionCounts
//    }
//}
