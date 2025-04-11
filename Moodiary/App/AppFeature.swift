//
//  AppFeature.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/7/25.
//

import Foundation
import SwiftUI
import ComposableArchitecture
// MARK: - 앱 전체 State 및 Reducer 정의

// 앱 전체 State
struct AppFeature: Reducer {
    struct State: Equatable {
        // 여러 기능의 State를 포함
        var navigation: NavigationFeature.State = .init()
        var feed: FeedFeature.State = .init()
        var insight: InsightFeature.State = .init()
        var profile: ProfileFeature.State = .init()
    }
    
    @CasePathable
    enum Action: Equatable {
        case navigation(NavigationFeature.Action)
        case feed(FeedFeature.Action)
        case insight(InsightFeature.Action)
        case profile(ProfileFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.navigation, action: \.navigation) {
            NavigationFeature()
        }
        
        Scope(state: \.feed, action: \.feed) {
            FeedFeature()
        }
        
        Scope(state: \.insight, action: \.insight) {
            InsightFeature()
        }
        
        Scope(state: \.profile, action: \.profile) {
            ProfileFeature()
        }
        
        Reduce { state, action in
            switch action {
                
            //MARK: FEED
                
            // 여기서 다른 Feature 간의 조율이 필요한 경우 처리
            case let .feed(.feedTapped(poest)):
                // feed에서 Detail로 이동 액션 처리
                return .send(.navigation(.navigate(to: .feedDetail(poest))))
//                
            case .feed(.feedBackButtonTapped):
                showTabBar()
                return .send(.navigation(.pop))
//
//            case let .home(.navigateToProfile(userId)):
//                // Home에서 Profile로 이동 액션 처리
//                let user = NavigationDestination.User(id: UUID(uuidString: userId) ?? UUID(), name: "사용자 \(userId)")
//                return .send(.navigation(.navigate(to: .profile(user))))
//                
                
            //MARK: INSIGHT
                
                
                
            //MARK: PROFILE
                
                
            //MARK: COMMON
                
//            case .detail(.backButtonTapped):
//                // Detail에서 뒤로가기 처리
//                return .send(.navigation(.pop))
//                
//            case .detail(.closeButtonTapped):
//                // Detail에서 루트로 돌아가기 처리
//                return .send(.navigation(.navigateToRoot))
                
            default:
                return .none
            }
        }
    }
}
