//
//  InsightStatModel+Mapper.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

// Models/Domain/InsightStatModel+Mapper.swift

import Foundation

extension InsightStatModel {
    init(dto: InsightStatResponseDTO) {
        self.date = ISO8601DateFormatter().date(from: dto.date) ?? Date()
        self.emotion = dto.emotion
        self.productivity = dto.productivity
    }
}

