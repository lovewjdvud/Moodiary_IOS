//
//  TagEmotionCard.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/13/25.
//

import SwiftUI
import ComposableArchitecture
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


