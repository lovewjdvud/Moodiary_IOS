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
        // 날짜 포맷팅 (Date -> String)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.string(from: dto.date)
        
        // 기본 점수 값 설정
        var baseOverallScore: Double
        var baseHappinessScore: Double
        var baseSadnessScore: Double
        var baseAngerScore: Double
        var baseAnxietyScore: Double
        var labels: [String]
        
        // 이모지에 따른 감정 점수 계산
        switch dto.emotion {
            case "😊": // 행복
                baseOverallScore = 8.0
                baseHappinessScore = 9.0
                baseSadnessScore = 2.0
                baseAngerScore = 1.0
                baseAnxietyScore = 2.0
                labels = ["행복"]
            case "😢": // 슬픔
                baseOverallScore = 4.0
                baseHappinessScore = 2.0
                baseSadnessScore = 8.0
                baseAngerScore = 3.0
                baseAnxietyScore = 5.0
                labels = ["슬픔"]
            case "😡": // 분노
                baseOverallScore = 3.0
                baseHappinessScore = 1.0
                baseSadnessScore = 4.0
                baseAngerScore = 9.0
                baseAnxietyScore = 6.0
                labels = ["분노"]
            case "😰": // 불안
                baseOverallScore = 3.0
                baseHappinessScore = 2.0
                baseSadnessScore = 5.0
                baseAngerScore = 4.0
                baseAnxietyScore = 8.0
                labels = ["불안"]
            default:
                baseOverallScore = 5.0
                baseHappinessScore = 5.0
                baseSadnessScore = 5.0
                baseAngerScore = 5.0
                baseAnxietyScore = 5.0
                labels = ["중립"]
        }
        
        // 생산성 반영
        let productivityBonus = Double(dto.productivity) * 0.5
        self.overallMoodScore = min(10.0, baseOverallScore + productivityBonus)
        
        // 나머지 속성들 초기화
        self.happinessMoodScore = baseHappinessScore
        self.sadnessMoodScore = baseSadnessScore
        self.angerMoodScore = baseAngerScore
        self.anxietyMoodScore = baseAnxietyScore
        self.dominantMoodLabels = labels
    }
}
