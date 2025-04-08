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
}

extension DependencyValues {
    var insightClient: InsightClient {
        get { self[InsightClient.self] }
        set { self[InsightClient.self] = newValue }
    }
}
