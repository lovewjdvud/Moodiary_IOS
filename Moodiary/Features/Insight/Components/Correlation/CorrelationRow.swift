//
//  CorrelationRow.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/13/25.
//

import SwiftUI

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
