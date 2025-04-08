//
//  CorrelationStatModel+Mapper.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

import Foundation

extension CorrelationStatModel {
    init(dto: CorrelationStatResponseDTO) {
        self.correlation = dto.correlationCoefficient
        self.summary = dto.summary
    }
}
