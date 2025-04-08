//
//  MainTabView.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 2025/03/30.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
    let store: StoreOf<MainTabFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            TabView(
                selection: viewStore.binding(
                    get: \.selectedTab,
                    send: MainTabFeature.Action.selectTab
                )
            ) {
                // 1. 피드
//                BoardView(store: store.scope(state: \.boardState, action: \.board))
                FeedView(store: store.scope(state: \.feed, action: \.feed))
                    .tag(Tab.feed)
                    .tabItem {
                        Image(viewStore.selectedTab == .feed ? "icon_feed_selected" : "icon_feed")
                        Text("피드")
                    }

                // 2. 인사이트
                InsightView(store: store.scope(state: \.insight, action: \.insight))
                    .tag(Tab.insight)
                    .tabItem {
                        Image(viewStore.selectedTab == .insight ? "icon_insight_selected" : "icon_insight")
                        Text("인사이트")
                    }

                // 3. 프로필
                ProfileView(store: store.scope(state: \.profile, action: \.profile))
                    .tag(Tab.profile)
                    .tabItem {
                        Image(viewStore.selectedTab == .profile ? "icon_profile_selected" : "icon_profile")
                        Text("프로필")
                    }
            }
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = UIColor.systemBackground
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}
