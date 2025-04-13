import SwiftUI
import Charts
import ComposableArchitecture

// MARK: - 주간 차트
struct WeeklyMoodChart: View {
    let store: StoreOf<InsightFeature>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 10) {
                

                    
                    MDTextView(text: "주간 감정 추이",
                             size: 25,
                             style: .bold,
                             color: .white)
                    
                
                Chart {
                        ForEach(viewStore.weeklyStats.sorted(by: {
                            DateFormatter.yearMonthDay.date(from: $0.date) ?? Date() <
                                DateFormatter.yearMonthDay.date(from: $1.date) ?? Date()
                        }), id: \.date) { stat in
                            
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
                      // 주간 차트일 때는 모든 요일 표시
                      AxisMarks(preset: .aligned, values: .automatic(desiredCount: 7)) { value in
                          if let day = value.as(String.self) {
                              AxisValueLabel {
                                  Text(day)
                                      .font(.system(size: 12, weight: .medium))
                                      .foregroundStyle(.white)
                              }
                          }
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        let calendar = Calendar.current
        let weekdayIndex = calendar.component(.weekday, from: date) - 1 // 1(일)~7(토) -> 0~6
        
        let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        return weekdays[weekdayIndex]
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
