//
//  InsightFeature.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 2025/03/30.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct InsightFeature: Reducer {

    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var dailyStats: InsightStatModel?
        var weeklyStats: [InsightStatModel] = []
        var monthlyStats: [InsightStatModel] = []

        var correlation: CorrelationStatModel?
        var tagEmotionStats: [TagEmotionStatModel] = []
        var report: PDFReportModel?

        var isLoading: Bool = false
        var errorMessage: String?
    }

    // MARK: - Action
    @CasePathable
    @dynamicMemberLookup
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case onAppear

        case fetchDaily(String)
        case fetchDailySuccess(InsightStatModel)
        case fetchDailyFailure(String)

        case fetchWeekly(String)
        case fetchWeeklySuccess([InsightStatModel])
        case fetchWeeklyFailure(String)

        case fetchMonthly(String)
        case fetchMonthlySuccess([InsightStatModel])
        case fetchMonthlyFailure(String)

        case fetchCorrelation
        case fetchCorrelationSuccess(CorrelationStatModel)
        case fetchCorrelationFailure(String)

        case fetchTagEmotion
        case fetchTagEmotionSuccess([TagEmotionStatModel])
        case fetchTagEmotionFailure(String)

        case fetchReport(String)
        case fetchReportSuccess(PDFReportModel)
        case fetchReportFailure(String)

        case cancelFail(CancelID, String)
    }

    // MARK: - Cancel IDs
    enum CancelID {
        case fetchDaily, fetchWeekly, fetchMonthly
        case fetchCorrelation, fetchTagEmotion, fetchReport
    }

    // MARK: - Dependencies
    @Dependency(\.insightClient) var insightClient

    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            case .binding:
                return .none

            case .onAppear:
                let today = DateFormatter.yearMonthDay.string(from: Date())
                let thisWeek = DateFormatter.yearMonthDay.string(from: Date().startOfWeek ?? Date())
                let thisMonth = DateFormatter.yearMonth.string(from: Date())

                return .merge([
                    .send(.fetchDaily(today)),
                    .send(.fetchWeekly(thisWeek)),
                    .send(.fetchMonthly(thisMonth)),
                    .send(.fetchCorrelation),
                    .send(.fetchTagEmotion)
                ])

            // MARK: - Daily
            case .fetchDaily(let date):
                return .run { send in
                    do {
                        let data = try await insightClient.fetchDailyStats(date)
                        await send(.fetchDailySuccess(data))
                    } catch {
                        await send(.fetchDailyFailure("일간 통계를 불러오지 못했습니다."))
                        await send(.cancelFail(.fetchDaily, error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.fetchDaily)

            case .fetchDailySuccess(let data):
                state.dailyStats = data
                return .none

            case .fetchDailyFailure(let message):
                state.errorMessage = message
                return .none

            // MARK: - Weekly
            case .fetchWeekly(let weekStart):
                return .run { send in
                    do {
                        let data = try await insightClient.fetchWeeklyStats(weekStart)
                        await send(.fetchWeeklySuccess(data))
                    } catch {
                        await send(.fetchWeeklyFailure("주간 통계를 불러오지 못했습니다."))
                        await send(.cancelFail(.fetchWeekly, error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.fetchWeekly)

            case .fetchWeeklySuccess(let data):
                state.weeklyStats = data
                return .none

            case .fetchWeeklyFailure(let message):
                state.errorMessage = message
                return .none

            // MARK: - Monthly
            case .fetchMonthly(let month):
                return .run { send in
                    do {
                        let data = try await insightClient.fetchMonthlyStats(month)
                        await send(.fetchMonthlySuccess(data))
                    } catch {
                        await send(.fetchMonthlyFailure("월간 통계를 불러오지 못했습니다."))
                        await send(.cancelFail(.fetchMonthly, error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.fetchMonthly)

            case .fetchMonthlySuccess(let data):
                state.monthlyStats = data
                return .none

            case .fetchMonthlyFailure(let message):
                state.errorMessage = message
                return .none

            // MARK: - Correlation
            case .fetchCorrelation:
                return .run { send in
                    do {
                        let result = try await insightClient.fetchCorrelationStats()
                        await send(.fetchCorrelationSuccess(result))
                    } catch {
                        await send(.fetchCorrelationFailure("상관관계를 불러오지 못했습니다."))
                        await send(.cancelFail(.fetchCorrelation, error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.fetchCorrelation)

            case .fetchCorrelationSuccess(let result):
                state.correlation = result
                return .none

            case .fetchCorrelationFailure(let message):
                state.errorMessage = message
                return .none

            // MARK: - Tag Emotion
            case .fetchTagEmotion:
                return .run { send in
                    do {
                        let data = try await insightClient.fetchTagEmotionStats()
                        await send(.fetchTagEmotionSuccess(data))
                    } catch {
                        await send(.fetchTagEmotionFailure("태그 감정 통계를 불러오지 못했습니다."))
                        await send(.cancelFail(.fetchTagEmotion, error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.fetchTagEmotion)

            case .fetchTagEmotionSuccess(let data):
                state.tagEmotionStats = data
                return .none

            case .fetchTagEmotionFailure(let message):
                state.errorMessage = message
                return .none

            // MARK: - Report
            case .fetchReport(let month):
                return .run { send in
                    do {
                        let report = try await insightClient.generateMonthlyReport(month)
                        await send(.fetchReportSuccess(report))
                    } catch {
                        await send(.fetchReportFailure("감정 리포트를 불러오지 못했습니다."))
                        await send(.cancelFail(.fetchReport, error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.fetchReport)

            case .fetchReportSuccess(let report):
                state.report = report
                return .none

            case .fetchReportFailure(let message):
                state.errorMessage = message
                return .none

            // MARK: - Cancel 처리
            case .cancelFail(let id, let message):
                print("❌ InsightFeature Cancel [\(id)] - \(message)")
                return .cancel(id: id)
            }
        }
    }
}
