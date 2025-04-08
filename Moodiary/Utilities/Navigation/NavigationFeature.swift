//
//  NavigationFeature.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/7/25.
//

import Foundation
import SwiftUI
import ComposableArchitecture

// MARK: - Navigation Feature

/// Navigation을 관리하는 Feature
public struct NavigationFeature: Reducer {
    public struct State: Equatable {
        public var path: [NavigationDestination]
        public var currentSelectedTab: Tab
        
        public init(
            path: [NavigationDestination] = [],
            currentSelectedTab: Tab = .feed
        ) {
            self.path = path
            self.currentSelectedTab = currentSelectedTab
        }
        
        public enum Tab: Hashable {
            case feed
            case insight
            case profile
            
            public var title: String {
                switch self {
                case .feed: return "홈"
                case .insight: return "분석"
                case .profile: return "프로필"
                }
            }
            
            public var iconName: String {
                switch self {
                case .feed: return "house"
                case .insight: return "magnifyingglass"
                case .profile: return "bell"
                }
            }
        }
    }
    
    public enum Action: Equatable {
        case navigate(to: NavigationDestination)
        case navigateToRoot
        case pop
        case popToIndex(Int)
        case selectTab(State.Tab)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .navigate(destination):
                state.path.append(destination)
                return .none
                
            case .navigateToRoot:
                state.path.removeAll()
                return .none
                
            case .pop:
                guard !state.path.isEmpty else { return .none }
                state.path.removeLast()
                return .none
                
            case let .popToIndex(index):
                guard index >= 0, index < state.path.count else { return .none }
                state.path = Array(state.path.prefix(through: index))
                return .none
                
            case let .selectTab(tab):
                state.currentSelectedTab = tab
                // 탭 변경 시 해당 탭의 네비게이션 스택 초기화
                state.path.removeAll()
                return .none
            }
        }
    }
}
