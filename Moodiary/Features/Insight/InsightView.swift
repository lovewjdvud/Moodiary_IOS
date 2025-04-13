import SwiftUI
import ComposableArchitecture
import Charts

// MARK: - InsightView
struct InsightView: View {
    
    let store: StoreOf<InsightFeature>
    
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
                            TimeRangeSelectorView(store: store)
                            
                            // 감정 타입 선택
                            MoodTypeSelectorView(store: store)
                            
                            // 일간 감정 상태 카드
                            if let dailyStats = viewStore.dailyStats {
                                DailyMoodCard(dailyStats: dailyStats)
                                    .padding(.horizontal)
                            }
                            
                            if store.selectedTimeRange == .week {
                                WeeklyMoodChart(
                                    store: store)
                                .frame(height: 250)
                                .padding(.horizontal)
                            } else {
                                MonthlyMoodChart(
                                    store: store
                                )
                                .frame(height: 300)
                                .padding(.horizontal)
                            }
                            
                            // 감정 상관관계
//                            if let correlation = viewStore.correlation {
//                                CorrelationCard(correlation: correlation)
//                                    .padding(.horizontal)
//                            }
//                            
//                            // 태그별 감정 통계
//                            if !viewStore.tagEmotionStats.isEmpty {
//                                TagEmotionCard(store: store)
//                                    .padding(.horizontal)
//                            }
//                            
//                            // 월간 리포트 버튼
//                            Button(action: {
//                                let thisMonth = DateFormatter.yearMonth.string(from: Date())
//                                viewStore.send(.fetchReport(thisMonth))
//                            }) {
//                                HStack {
//                                    Image(systemName: "doc.text")
//                                    Text("월간 감정 리포트")
//                                }
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.purple)
//                                .cornerRadius(15)
//                            }
//                            .padding(.horizontal)
//                            .padding(.top, 8)
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
    // 빈 차트 표시를 위한 뷰
       private var emptyChartView: some View {
           VStack {
               Spacer()
               Text("데이터가 없습니다")
                   .foregroundColor(.gray)
               Spacer()
           }
           .frame(height: 200)
       }
}

// MARK: - 시간 범위 선택기 뷰
struct TimeRangeSelectorView: View {
    let store: StoreOf<InsightFeature>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(TimeRange.allCases, id: \.self) { timeRange in
                        Button(action: {
                            viewStore.send(.setSelectedTimeRange(timeRange))
//                            viewStore.send(.binding(.set(\.$selectedTimeRange, timeRange)))
                        }) {
                            Text(timeRange.displayName)
                                .foregroundColor(viewStore.selectedTimeRange == timeRange ? .white : .gray)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 15)
                                .background(viewStore.selectedTimeRange == timeRange ? Color.purple : Color.clear)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .background(Color.black)
        }
    }
}

// MARK: - 감정 타입 선택기 뷰
struct MoodTypeSelectorView: View {
    let store: StoreOf<InsightFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                   ForEach(MoodType.allCases, id: \.self) { moodType in
                       Button(action: {
                           viewStore.send(.setSelectedMoodType(moodType))
                       }) {
                           Text(moodType.displayName)
                               .foregroundColor(viewStore.selectedMoodType == moodType ? moodTypeColor(moodType) : .gray)
                               .padding(.vertical, 8)
                               .padding(.horizontal, 15)
                               .background(viewStore.selectedMoodType == moodType ? moodTypeColor(moodType).opacity(0.2) : Color.clear)
                               .cornerRadius(20)
                       }
                   }
                }
                .padding(.horizontal)
            }
            .background(Color.black)
        }
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


