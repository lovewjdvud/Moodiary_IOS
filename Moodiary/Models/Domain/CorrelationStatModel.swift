//
//  CorrelationStatModel.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

import Foundation

struct CorrelationStatModel: Equatable ,Codable{
    let correlation: CorrelationCoefficient
    let summary: String
    
    // CorrelationCoefficient 구조체 정의가 필요할 수 있습니다
    struct CorrelationCoefficient: Equatable,Codable {
        let happinessSadness: Double
        let happinessAnger: Double
        let happinessAnxiety: Double
        let sadnessAnger: Double
        let sadnessAnxiety: Double
        let angerAnxiety: Double
    }
}
