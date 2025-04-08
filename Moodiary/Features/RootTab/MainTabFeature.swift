//
//  MainTabFeature.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

import SwiftUI
import ComposableArchitecture
// MainTabFeature.swift

// MARK: - Tab 정의
enum Tab: Hashable {
    case feed
    case insight
    case profile
}


struct MainTabFeature: Reducer {

    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var selectedTab: Tab = .feed
        var feed = FeedFeature.State()
        var insight = InsightFeature.State()
        var profile = ProfileFeature.State()
    }

    // MARK: - Action
    @CasePathable
    @dynamicMemberLookup
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case selectTab(Tab)

        case feed(FeedFeature.Action)
        case insight(InsightFeature.Action)
        case profile(ProfileFeature.Action)
    }

    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()


        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .selectTab(let tab):
                state.selectedTab = tab
                return .none

            // 자식 액션은 Scope로 분기했기 때문에 여기선 처리 안 함
            case .feed, .insight, .profile:
                return .none
            }
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
    }
}
