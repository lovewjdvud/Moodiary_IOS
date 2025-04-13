//
//  InsightClient.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 2025/03/30.
//

import Foundation
import ComposableArchitecture
import Dependencies

struct InsightClient {
    
    var fetchDailyStats: @Sendable (_ date: String) async throws -> InsightStatModel
    var fetchWeeklyStats: @Sendable (_ weekStart: String) async throws -> [InsightStatModel]
    var fetchMonthlyStats: @Sendable (_ month: String) async throws -> [InsightStatModel]
    var fetchCorrelationStats: @Sendable () async throws -> CorrelationStatModel
    var fetchTagEmotionStats: @Sendable () async throws -> [TagEmotionStatModel]
    var generateMonthlyReport: @Sendable (_ month: String) async throws -> PDFReportModel
    
}

extension InsightClient: DependencyKey {
    static let liveValue: Self = {
        let networkManager = NetworkManager(baseURL: Config.baseURL)

        return Self(
            
            // 1. 일간 통계 조회
            fetchDailyStats: { date in
                try await networkManager.request(
                    "/insight/daily?date=\(date)",
                    method: .get,
                    requiresAuth: true
                )
            },
            
            // 2. 주간 통계 조회
            fetchWeeklyStats: { weekStart in
                try await networkManager.request(
                    "/insight/weekly?start=\(weekStart)",
                    method: .get,
                    requiresAuth: true
                )
            },
            
            // 3. 월간 통계 조회
            fetchMonthlyStats: { month in
                try await networkManager.request(
                    "/insight/monthly?month=\(month)",
                    method: .get,
                    requiresAuth: true
                )
            },
            
            // 4. 감정-생산성 상관관계 분석
            fetchCorrelationStats: {
                try await networkManager.request(
                    "/insight/correlation",
                    method: .get,
                    requiresAuth: true
                )
            },
            
            // 5. 태그별 감정 통계
            fetchTagEmotionStats: {
                try await networkManager.request(
                    "/insight/tag-emotion",
                    method: .get,
                    requiresAuth: true
                )
            },
            
            // 6. 감정 리포트 PDF 생성 (프리미엄)
            generateMonthlyReport: { month in
                try await networkManager.request(
                    "/insight/report?month=\(month)",
                    method: .get,
                    requiresAuth: true
                )
            }
            
        )
    }()
    // 유연한 테스트를 위한 mock 함수
    static func mock(
       fetchDailyStats: @escaping @Sendable (_ date: String) async throws -> InsightStatModel = { _ in fatalError("Not implemented") },
       fetchWeeklyStats: @escaping @Sendable (_ weekStart: String) async throws -> [InsightStatModel] = { _ in fatalError("Not implemented") },
       fetchMonthlyStats: @escaping @Sendable (_ month: String) async throws -> [InsightStatModel] = { _ in fatalError("Not implemented") },
       fetchCorrelationStats: @escaping @Sendable () async throws -> CorrelationStatModel = { fatalError("Not implemented") },
       fetchTagEmotionStats: @escaping @Sendable () async throws -> [TagEmotionStatModel] = { fatalError("Not implemented") },
       generateMonthlyReport: @escaping @Sendable (_ month: String) async throws -> PDFReportModel = { _ in fatalError("Not implemented") }
    ) -> Self {
       Self(
           fetchDailyStats: fetchDailyStats,
           fetchWeeklyStats: fetchWeeklyStats,
           fetchMonthlyStats: fetchMonthlyStats,
           fetchCorrelationStats: fetchCorrelationStats,
           fetchTagEmotionStats: fetchTagEmotionStats,
           generateMonthlyReport: generateMonthlyReport
       )
    }
    
    static let testValue: Self = {
        return Self(
            fetchDailyStats: { _ in
                return InsightStatModel(
                    date: "2025-03-30",
                    overallMoodScore: 7.0,
                    happinessMoodScore: 8.0,
                    sadnessMoodScore: 2.0,
                    angerMoodScore: 1.0,
                    anxietyMoodScore: 3.0,
                    dominantMoodLabels: ["행복"]
                )
            },
            
            fetchWeeklyStats: { _ in
                return [
                    InsightStatModel(
                        date: "2025-03-30",
                        overallMoodScore: 7.0,
                        happinessMoodScore: 8.0,
                        sadnessMoodScore: 2.0,
                        angerMoodScore: 1.0,
                        anxietyMoodScore: 3.0,
                        dominantMoodLabels: ["행복"]
                    )
                ]
            },
            
            fetchMonthlyStats: { _ in
                return [
                    InsightStatModel(
                        date: "2025-03-30",
                        overallMoodScore: 7.0,
                        happinessMoodScore: 8.0,
                        sadnessMoodScore: 2.0,
                        angerMoodScore: 1.0,
                        anxietyMoodScore: 3.0,
                        dominantMoodLabels: ["행복"]
                    )
                ]
            },
            
            fetchCorrelationStats: {
                return CorrelationStatModel(
                    correlation: .init(
                        happinessSadness: 0.5,
                        happinessAnger: -0.3,
                        happinessAnxiety: 0.2,
                        sadnessAnger: 0.4,
                        sadnessAnxiety: -0.1,
                        angerAnxiety: 0.6
                    ),
                    summary: "테스트 상관관계"
                )
            },
            
            fetchTagEmotionStats: {
                return [
                    TagEmotionStatModel(
                        id: 1,
                        tag: "행복",
                        emotionCounts: ["happiness": 3, "sadness": 1]
                    )
                ]
            },
            
            generateMonthlyReport: { _ in
                return PDFReportModel(
                    month: "2025-03",
                    summary: "테스트 요약",
                    mostFrequentEmotion: "행복",
                    averageProductivity: 7.5,
                    chartImageURL: "https://example.com/chart.png",
                    url: URL(string: "https://example.com/report.pdf")!,
                    title: "테스트 리포트"
                )
            }
        )
    }()
}

extension DependencyValues {
    var insightClient: InsightClient {
        get { self[InsightClient.self] }
        set { self[InsightClient.self] = newValue }
    }
}
