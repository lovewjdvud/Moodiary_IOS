//
//  CorrelationStatModel+Mapper.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

import Foundation

extension CorrelationStatModel {
    init(dto: CorrelationStatResponseDTO) {
        // correlationCoefficient가 단일 Double 값이므로, 여러 상관관계에 동일한 값을 사용하거나
        // 또는 다른 방식으로 데이터를 매핑해야 합니다.
        self.correlation = CorrelationCoefficient(
            happinessSadness: dto.correlationCoefficient,
            happinessAnger: dto.correlationCoefficient,
            happinessAnxiety: dto.correlationCoefficient,
            sadnessAnger: dto.correlationCoefficient,
            sadnessAnxiety: dto.correlationCoefficient,
            angerAnxiety: dto.correlationCoefficient
        )
        
        self.summary = dto.summary
    }
}
