//
//  TimeRange.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/13/25.
//

import Foundation

// 시간 범위 열거형
enum TimeRange: String, CaseIterable {
    case day = "day"
    case week = "week"
    case month = "month"
    
    var displayName: String {
        switch self {
        case .day: return "일간"
        case .week: return "주간"
        case .month: return "월간"
        }
    }
}
