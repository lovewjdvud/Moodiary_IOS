//
//  MonthlyMoodChart.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/13/25.
//

import SwiftUI
import Charts
import ComposableArchitecture

// MARK: - 월간 차트
struct MonthlyMoodChart: View {
    let store: StoreOf<InsightFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 10) {
                MDTextView(text: "1달 감정 추이",
                         size: 20,
                         style: .bold,
                         color: .white)
                
                Chart {
                    ForEach(viewStore.monthlyStats.sorted { stat1, stat2 in
                        let date1 = DateFormatter.yearMonthDay.date(from: stat1.date) ?? Date()
                        let date2 = DateFormatter.yearMonthDay.date(from: stat2.date) ?? Date()
                        return date1 < date2
                    }, id: \.date) { stat in
                        BarMark(
                            x: .value("Day", getDayNumber(stat.date)),
                            y: .value("Score", scoreForType(stat, type: viewStore.selectedMoodType))
                        )
                        .foregroundStyle(colorForMoodType(viewStore.selectedMoodType))
                    }
                    
//                    ForEach(viewStore.monthlyStats, id: \.date) { stat in
//                        BarMark(
//                            x: .value("Day", getDayNumber(stat.date)),
//                            y: .value("Score", scoreForType(stat, type: viewStore.selectedMoodType))
//                        )
//                        .foregroundStyle(colorForMoodType(viewStore.selectedMoodType))
//                    }
                }
                .chartYScale(domain: 0...10)
                .chartXScale(domain: 0...32) // 0부터 32까지로 범위 확장 (여백 포함)
                .chartYAxis {
                    AxisMarks(position: .leading) { _ in
                        AxisValueLabel()
                            .foregroundStyle(.gray)
                    }
                }
                .chartXAxis {
                    AxisMarks(values: [5, 10, 15, 20, 25, 30]) { value in // 특정 날짜만 표시 (30일까지)
                        if let day = value.as(Int.self) {
                            AxisValueLabel {
                                Text("\(day)")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(.white)
                            }
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                                .foregroundStyle(Color.gray.opacity(0.5))
                        }
                    }
                }
                .chartPlotStyle { plotArea in
                    plotArea
                        .frame(height: 200)
                        .padding(.horizontal, 0) // 차트 양쪽에 패딩 추가
                }
            }
            .padding()
            .background(Color(white: 0.2))
            .cornerRadius(15)
        }
    }
    
    // 날짜 문자열에서 일(day) 숫자만 추출
    private func getDayNumber(_ dateString: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: dateString) else {
            return 1 // 기본값
        }
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        
        return day
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
