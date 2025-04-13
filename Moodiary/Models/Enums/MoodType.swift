//
//  MoodType.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/13/25.
//

import Foundation

// 감정 타입 열거형
enum MoodType: String, CaseIterable {
    case overall = "overall"
    case happiness = "happiness"
    case sadness = "sadness"
    case anger = "anger"
    case anxiety = "anxiety"
    
    var displayName: String {
        switch self {
        case .overall: return "종합"
        case .happiness: return "행복"
        case .sadness: return "슬픔"
        case .anger: return "분노"
        case .anxiety: return "불안"
        }
    }
}
