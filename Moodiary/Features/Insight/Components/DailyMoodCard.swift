//
//  DailyMoodCard.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/13/25.
//

import Foundation
import SwiftUI
// MARK: - 일간 감정 카드
struct DailyMoodCard: View {
    let dailyStats: InsightStatModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("오늘의 감정")
                    .font(.headline)
                    .foregroundColor(.white)
                
                MDTextView(text: "감정 인사이트",
                           size: 16,
                           style: .semiBold,
                           color: .white)
                
             
                Spacer()
                
                Text(formatDate(dailyStats.date))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 15) {
                EmotionScoreView(
                    score: dailyStats.overallMoodScore,
                    label: "종합",
                    color: .purple
                )
                
                EmotionScoreView(
                    score: dailyStats.happinessMoodScore,
                    label: "행복",
                    color: .green
                )
                
                EmotionScoreView(
                    score: dailyStats.sadnessMoodScore,
                    label: "슬픔",
                    color: .blue
                )
                
                EmotionScoreView(
                    score: dailyStats.angerMoodScore,
                    label: "분노",
                    color: .red
                )
                
                EmotionScoreView(
                    score: dailyStats.anxietyMoodScore,
                    label: "불안",
                    color: .orange
                )
            }
            
            if !dailyStats.dominantMoodLabels.isEmpty {
                HStack {
                    Text("주요 감정:")
                        .foregroundColor(.gray)
                    
                    ForEach(dailyStats.dominantMoodLabels, id: \.self) { emotion in
                        Text(emotion)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.purple.opacity(0.3))
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 5)
            }
        }
        .padding()
        .background(Color(white: 0.2))
        .cornerRadius(15)
    }
    
    private func formatDate(_ dateString: String) -> String {
        // 실제 앱에서는 날짜 포매팅 로직 구현
        return dateString
    }
}
