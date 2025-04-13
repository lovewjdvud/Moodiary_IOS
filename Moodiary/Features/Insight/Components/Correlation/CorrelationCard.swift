//
//  CorrelationCard.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/13/25.
//

import SwiftUI

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
