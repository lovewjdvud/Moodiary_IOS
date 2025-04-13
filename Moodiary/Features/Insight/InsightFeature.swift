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
        var selectWeekAndMonthlyStats: [InsightStatModel] = []
        
        var correlation: CorrelationStatModel?
        var tagEmotionStats: [TagEmotionStatModel] = []
        var report: PDFReportModel?

        var isLoading: Bool = false
        var errorMessage: String?

        var selectedTimeRange: TimeRange = .week
        var selectedMoodType: MoodType = .overall
        var selectedMoodScore: Double?
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

        case setSelectedTimeRange(TimeRange)
        case setSelectedChartTime([InsightStatModel])
        case setSelectedMoodType(MoodType)
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
//                        let data = try await insightClient.fetchDailyStats(date)
                        
                        let data = InsightStatModel(date: date,
                                         overallMoodScore: 8.5,
                                         happinessMoodScore: 9.0,
                                         sadnessMoodScore: 1.0,
                                         angerMoodScore: 0.5,
                                         anxietyMoodScore: 2.0,
                                         dominantMoodLabels: ["행복", "기쁨"]
                                                                )
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
//                        let data = try await insightClient.fetchWeeklyStats(weekStart)
                        
                        let data = [
                                                   InsightStatModel(
                                                       date: weekStart,
                                                       overallMoodScore: 7.5,
                                                       happinessMoodScore: 8.0,
                                                       sadnessMoodScore: 2.0,
                                                       angerMoodScore: 1.5,
                                                       anxietyMoodScore: 3.0,
                                                       dominantMoodLabels: ["행복"]
                                                   ),
                                                   InsightStatModel(
                                                       date: DateFormatter.yearMonthDay.string(from: Calendar.current.date(byAdding: .day, value: 1, to: DateFormatter.yearMonthDay.date(from: weekStart) ?? Date()) ?? Date()),
                                                       overallMoodScore: 6.8,
                                                       happinessMoodScore: 7.5,
                                                       sadnessMoodScore: 2.5,
                                                       angerMoodScore: 2.0,
                                                       anxietyMoodScore: 3.5,
                                                       dominantMoodLabels: ["행복", "평온"]
                                                   ),
                                                   InsightStatModel(
                                                       date: DateFormatter.yearMonthDay.string(from: Calendar.current.date(byAdding: .day, value: 2, to: DateFormatter.yearMonthDay.date(from: weekStart) ?? Date()) ?? Date()),
                                                       overallMoodScore: 7.2,
                                                       happinessMoodScore: 8.2,
                                                       sadnessMoodScore: 1.8,
                                                       angerMoodScore: 1.2,
                                                       anxietyMoodScore: 2.8,
                                                       dominantMoodLabels: ["행복"]
                                                   )
                                               ]
                        
                        await send(.fetchWeeklySuccess(data))
                    } catch {
                        await send(.fetchWeeklyFailure("주간 통계를 불러오지 못했습니다."))
                        await send(.cancelFail(.fetchWeekly, error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.fetchWeekly)

            case .fetchWeeklySuccess(let data):
                state.weeklyStats = data
                state.selectWeekAndMonthlyStats = data
                return .none

            case .fetchWeeklyFailure(let message):
                state.errorMessage = message
                return .none

            // MARK: - Monthly
            case .fetchMonthly(let month):
                return .run { send in
                    do {
//                        let data = try await insightClient.fetchMonthlyStats(month)
                        // 모의 데이터 사용
                        let data = (1...30).map { day in
                            let dayStr = day < 10 ? "0\(day)" : "\(day)"
                            return InsightStatModel(
                                date: "\(month)-\(dayStr)",
                                overallMoodScore: Double.random(in: 6...9),
                                happinessMoodScore: Double.random(in: 7...9),
                                sadnessMoodScore: Double.random(in: 1...3),
                                angerMoodScore: Double.random(in: 0...2),
                                anxietyMoodScore: Double.random(in: 1...4),
                                dominantMoodLabels: ["행복", "기쁨", "평온"].randomElement().map { [$0] } ?? ["행복"]
                            )
                        }
                        await send(.fetchMonthlySuccess(data))
                    } catch {
                        await send(.fetchMonthlyFailure("월간 통계를 불러오지 못했습니다."))
                        await send(.cancelFail(.fetchMonthly, error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.fetchMonthly)

            case .fetchMonthlySuccess(let data):
                state.monthlyStats = data
//                state.selectWeekAndMonthlyStats = data
                return .none

            case .fetchMonthlyFailure(let message):
                state.errorMessage = message
                return .none

            // MARK: - Correlation
            case .fetchCorrelation:
                return .run { send in
                    do {
//                        let correlation = try await insightClient.fetchCorrelationStats()
                        
                        // 모의 데이터 사용
                        let correlation = CorrelationStatModel(
                            correlation: .init(
                                happinessSadness: -0.65,
                                happinessAnger: -0.78,
                                happinessAnxiety: -0.55,
                                sadnessAnger: 0.42,
                                sadnessAnxiety: 0.68,
                                angerAnxiety: 0.51
                            ),
                            summary: "행복감이 높을수록 부정적인 감정은 감소하는 경향이 있습니다. 슬픔과 불안 사이에는 강한 양의 상관관계가 있습니다."
                        )
                        await send(.fetchCorrelationSuccess(correlation))
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
//                        let tagEmotions = try await insightClient.fetchTagEmotionStats()
                        // 모의 데이터 사용
                        let tagEmotions = [
                            TagEmotionStatModel(
                                id: 1,
                                tag: "가족",
                                emotionCounts: ["happiness": 12, "sadness": 3, "anger": 1, "anxiety": 2]
                            ),
                            TagEmotionStatModel(
                                id: 2,
                                tag: "직장",
                                emotionCounts: ["happiness": 8, "sadness": 5, "anger": 4, "anxiety": 7]
                            ),
                            TagEmotionStatModel(
                                id: 3,
                                tag: "취미",
                                emotionCounts: ["happiness": 15, "sadness": 1, "anger": 0, "anxiety": 2]
                            ),
                            TagEmotionStatModel(
                                id: 4,
                                tag: "건강",
                                emotionCounts: ["happiness": 6, "sadness": 4, "anger": 2, "anxiety": 5]
                            )
                        ]
                        await send(.fetchTagEmotionSuccess(tagEmotions))
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
//                        let report = try await insightClient.generateMonthlyReport(month)
                        // 모의 데이터 사용
                         let report = PDFReportModel(
                             month: month,
                             summary: "이번 달에는 전반적으로 긍정적인 감정이 우세했습니다. 가족 관련 활동이 가장 많은 행복감을 주었으며, 직장 관련 활동에서는 불안감이 다소 높았습니다.",
                             mostFrequentEmotion: "행복",
                             averageProductivity: 7.8,
                             chartImageURL: "https://example.com/chart-\(month).png",
                             url: URL(string: "https://example.com/report-\(month).pdf")!,
                             title: "\(month) 감정 리포트"
                         )
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

            case .setSelectedTimeRange(let timeRange):
                state.selectedTimeRange = timeRange
                return .none


            case .setSelectedMoodType(let moodType):
//                state.selectedMoodScore =
                
                state.selectedMoodType = moodType
                return .none
                
            case .setSelectedChartTime(let timeState):
                state.selectWeekAndMonthlyStats = timeState
                return .none
            // MARK: - Cancel 처리
            case .cancelFail(let id, let message):
                print("❌ InsightFeature Cancel [\(id)] - \(message)")
                return .cancel(id: id)

            }
        }
    }
}
