//
//  WeeklyMoodChart.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/13/25.
//

import SwiftUI
import Charts
import ComposableArchitecture

// MARK: - 주간 차트
struct WeeklyMoodChart2: View {
    let store: StoreOf<InsightFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 10) {
                Text("주간 감정 추이")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Chart {
                    ForEach(viewStore.weeklyStats, id: \.date) { stat in
                        LineMark(
                            x: .value("Day", formatDayOfWeek(stat.date)),
                            y: .value("Score", scoreForType(stat, type: viewStore.selectedMoodType))
                        )
                        .foregroundStyle(colorForMoodType(viewStore.selectedMoodType))
                        
                        PointMark(
                            x: .value("Day", formatDayOfWeek(stat.date)),
                            y: .value("Score", scoreForType(stat, type: viewStore.selectedMoodType))
                        )
                        .foregroundStyle(colorForMoodType(viewStore.selectedMoodType))
                    }
                }
                .chartYScale(domain: 0...10)
                .chartYAxis {
                    AxisMarks(position: .leading) { _ in
                        AxisValueLabel()
                            .foregroundStyle(.gray)
                    }
                }
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel()
                            .foregroundStyle(.gray)
                    }
                }
                .frame(height: 200)
            }
            .padding()
            .background(Color(white: 0.2))
            .cornerRadius(15)
        }
    }
    
    private func formatDayOfWeek(_ dateString: String) -> String {
        // 날짜 문자열에서 요일 추출 (실제 앱에서 구현)
        let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        let index = Int.random(in: 0...6) // 임시 구현
        return weekdays[index]
    }
    
    private func scoreForType(_ stat: InsightStatModel, type: MoodType) -> Double {
        switch type {
        case .overall: return stat.overallMoodScore
        case .happiness: return stat.happinessMoodScore
        case .sadness: return stat.sadnessMoodScore
        case .anger: return stat.angerMoodScore
        case .anxiety: return stat.anxietyMoodScore
        }
    }
    
    private func colorForMoodType(_ type: MoodType) -> Color {
        switch type {
        case .overall: return .purple
        case .happiness: return .green
        case .sadness: return .blue
        case .anger: return .red
        case .anxiety: return .orange
        }
    }
}
