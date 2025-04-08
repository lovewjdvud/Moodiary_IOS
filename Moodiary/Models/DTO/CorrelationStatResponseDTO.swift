//
//  CorrelationStatResponseDTO.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

// Models/DTO/CorrelationStatResponseDTO.swift

import Foundation

struct CorrelationStatResponseDTO: Codable {
    let correlationCoefficient: Double  // 예: 0.78
    let summary: String                 // "긍정 감정일수록 생산성이 높았습니다."
}

