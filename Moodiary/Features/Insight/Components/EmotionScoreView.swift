//
//  EmotionScoreView.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/13/25.
//

import SwiftUI

// MARK: - 감정 점수 뷰
struct EmotionScoreView: View {
    let score: Double
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 3)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: CGFloat(min(score / 10.0, 1.0)))
                    .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                
                Text(String(format: "%.1f", score))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(color)
            }
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}
