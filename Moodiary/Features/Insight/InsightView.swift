import SwiftUI
import ComposableArchitecture
import Charts

// MARK: - InsightView
struct InsightView: View {
    
    let store: StoreOf<InsightFeature>
    @State private var selectedTimeRange: TimeRange = .week
    @State private var selectedMoodType: MoodType = .overall
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if viewStore.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                        .scaleEffect(1.5)
                } else if let errorMessage = viewStore.errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.yellow)
                            .padding()
                        
                        MDTextView(text: errorMessage,
                                 size: 25,
                                 style: .bold,
                                   color: .white,
                                   alignment:.center)
                        .padding()
                 
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // 제목
                            MDTextView(text: "감정 인사이트",
                                     size: 25,
                                     style: .bold,
                                     color: .white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            
                            // 시간 범위 선택
                            timeRangeSelector
                            
                            // 감정 타입 선택
                            moodTypeSelector
                            
                            // 일간 감정 상태 카드
                            if let dailyStats = viewStore.dailyStats {
                                DailyMoodCard(dailyStats: dailyStats)
                                    .padding(.horizontal)
                            }
                            
                            // 주간 그래프
                            if !viewStore.weeklyStats.isEmpty {
                                WeeklyMoodChart(
                                    weeklyStats: viewStore.weeklyStats,
                                    selectedMoodType: selectedMoodType
                                )
                                .frame(height: 250)
                                .padding(.horizontal)
                            }
                            
                            // 월간 그래프
                            if !viewStore.monthlyStats.isEmpty {
                                MonthlyMoodChart(
                                    monthlyStats: viewStore.monthlyStats,
                                    selectedMoodType: selectedMoodType
                                )
                                .frame(height: 300)
                                .padding(.horizontal)
                            }
                            
                            // 감정 상관관계
                            if let correlation = viewStore.correlation {
                                CorrelationCard(correlation: correlation)
                                    .padding(.horizontal)
                            }
                            
                            // 태그별 감정 통계
                            if !viewStore.tagEmotionStats.isEmpty {
                                TagEmotionCard(store: store)
                                    .padding(.horizontal)
                            }
                            
                            // 월간 리포트 버튼
                            Button(action: {
                                let thisMonth = DateFormatter.yearMonth.string(from: Date())
                                viewStore.send(.fetchReport(thisMonth))
                            }) {
                                HStack {
                                    Image(systemName: "doc.text")
                                    Text("월간 감정 리포트")
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .cornerRadius(15)
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
    
    // MARK: - 시간 범위 선택기
    private var timeRangeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(TimeRange.allCases, id: \.self) { timeRange in
                    Button(action: {
                        selectedTimeRange = timeRange
                    }) {
                        Text(timeRange.displayName)
                            .foregroundColor(selectedTimeRange == timeRange ? .white : .gray)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background(selectedTimeRange == timeRange ? Color.purple : Color.clear)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(Color.black)
    }
    
    // MARK: - 감정 타입 선택기
    private var moodTypeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(MoodType.allCases, id: \.self) { moodType in
                    Button(action: {
                        selectedMoodType = moodType
                    }) {
                        Text(moodType.displayName)
                            .foregroundColor(selectedMoodType == moodType ? moodTypeColor(moodType) : .gray)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background(selectedMoodType == moodType ? moodTypeColor(moodType).opacity(0.2) : Color.clear)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(Color.black)
    }
    
    private func moodTypeColor(_ type: MoodType) -> Color {
        switch type {
        case .overall: return .purple
        case .happiness: return .green
        case .sadness: return .blue
        case .anger: return .red
        case .anxiety: return .orange
        }
    }
}


// MARK: - 주간 차트
struct WeeklyMoodChart: View {
    let weeklyStats: [InsightStatModel]
    let selectedMoodType: MoodType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("주간 감정 추이")
                .font(.headline)
                .foregroundColor(.white)
            
            Chart {
                ForEach(weeklyStats, id: \.date) { stat in
                    LineMark(
                        x: .value("Day", formatDayOfWeek(stat.date)),
                        y: .value("Score", scoreForType(stat, type: selectedMoodType))
                    )
                    .foregroundStyle(colorForMoodType(selectedMoodType))
                    
                    PointMark(
                        x: .value("Day", formatDayOfWeek(stat.date)),
                        y: .value("Score", scoreForType(stat, type: selectedMoodType))
                    )
                    .foregroundStyle(colorForMoodType(selectedMoodType))
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

// MARK: - 월간 차트
struct MonthlyMoodChart: View {
    let monthlyStats: [InsightStatModel]
    let selectedMoodType: MoodType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("월간 감정 변화")
                .font(.headline)
                .foregroundColor(.white)
            
            Chart {
                ForEach(monthlyStats, id: \.date) { stat in
                    BarMark(
                        x: .value("Day", formatDay(stat.date)),
                        y: .value("Score", scoreForType(stat, type: selectedMoodType))
                    )
                    .foregroundStyle(colorForMoodType(selectedMoodType))
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
    
    private func formatDay(_ dateString: String) -> String {
        // 날짜 문자열에서 일자 추출 (실제 앱에서 구현)
        return String(Int.random(in: 1...30)) // 임시 구현
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

// MARK: - 상관관계 카드
struct CorrelationCard: View {
    let correlation: CorrelationStatModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("감정 상관관계")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("당신의 감정들은 서로 어떤 관계가 있는지 보여줍니다")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            
            VStack(spacing: 10) {
                CorrelationRow(label: "행복 / 슬픔", value: correlation.correlation.happinessSadness)
                CorrelationRow(label: "행복 / 분노", value: correlation.correlation.happinessAnger)
                CorrelationRow(label: "행복 / 불안", value: correlation.correlation.happinessAnxiety)
                CorrelationRow(label: "슬픔 / 분노", value: correlation.correlation.sadnessAnger)
                CorrelationRow(label: "슬픔 / 불안", value: correlation.correlation.sadnessAnxiety)
                CorrelationRow(label: "분노 / 불안", value: correlation.correlation.angerAnxiety)
            }
        }
        .padding()
        .background(Color(white: 0.2))
        .cornerRadius(15)
    }
}

// MARK: - 상관관계 행
struct CorrelationRow: View {
    let label: String
    let value: Double
    
    var correlationColor: Color {
        if value > 0.7 {
            return .green
        } else if value > 0.3 {
            return .yellow
        } else if value > 0 {
            return .orange
        } else if value > -0.3 {
            return .red
        } else {
            return .blue
        }
    }
    
    var correlationText: String {
        if value > 0.7 {
            return "강한 정적 상관"
        } else if value > 0.3 {
            return "중간 정적 상관"
        } else if value > 0 {
            return "약한 정적 상관"
        } else if value > -0.3 {
            return "약한 부적 상관"
        } else if value > -0.7 {
            return "중간 부적 상관"
        } else {
            return "강한 부적 상관"
        }
    }
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.white)
            
            Spacer()
            
            Text(String(format: "%.2f", value))
                .foregroundColor(correlationColor)
                .font(.system(.body, design: .monospaced))
            
            Text(correlationText)
                .font(.caption)
                .foregroundColor(correlationColor)
        }
    }
}

// MARK: - 태그 감정 카드
struct TagEmotionCard: View {
    let store: StoreOf<InsightFeature>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 12) {
                Text("태그별 감정 통계")
                    .font(.headline)
                    .foregroundColor(.white)
                
                if viewStore.tagEmotionStats.count == 0 {
                    Text("아직 태그별 감정 데이터가 충분하지 않습니다")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    VStack(spacing: 15) {
                        ForEach(viewStore.tagEmotionStats, id: \.id) { stat in
                            VStack(alignment: .leading, spacing: 5) {
                                Text("#\(String(describing: stat.tag))")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Color.green)
                                        .frame(width: CGFloat(stat.happinessPercent) * 3, height: 8)
                                    
                                    Rectangle()
                                        .fill(Color.blue)
                                        .frame(width: CGFloat(stat.sadnessPercent) * 3, height: 8)
                                    
                                    Rectangle()
                                        .fill(Color.red)
                                        .frame(width: CGFloat(stat.angerPercent) * 3, height: 8)
                                    
                                    Rectangle()
                                        .fill(Color.orange)
                                        .frame(width: CGFloat(stat.anxietyPercent) * 3, height: 8)
                                }
                                .cornerRadius(4)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color(white: 0.2))
            .cornerRadius(15)
        }
    }
}


