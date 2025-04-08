//
//  TagEmotionStatModel.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//


import Foundation

struct TagEmotionStatModel: Equatable,Decodable, Identifiable {
    let id = UUID()
    let tag: String
    let emotionCounts: [String: Int]
}

extension TagEmotionStatModel {
    init(dto: TagEmotionStatResponseDTO) {
        self.tag = dto.tag
        self.emotionCounts = dto.emotionCounts
    }
}
