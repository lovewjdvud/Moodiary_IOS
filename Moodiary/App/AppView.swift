//
//  AppView.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/7/25.
//

import SwiftUI
import ComposableArchitecture
struct AppView: View {
    let store: StoreOf<AppFeature>
    var body: some View {
        TabNavigationView(
            store: store.scope(
                state: \.navigation,
                action: \.navigation
            ),
            tabContent: { tab in
                // 각 탭에 맞는 뷰 반환
                switch tab {
                case .feed:
                    FeedView(
                        store: store.scope(
                            state: \.feed,
                            action: \.feed
                        )
                    )
                    .navigationBarHidden(true) // 네비게이션 바 숨기기

                case .insight:
                    InsightView(
                        store: store.scope(
                            state: \.insight,
                            action: \.insight
                        )
                    )
                    .navigationBarHidden(true) // 네비게이션 바 숨기기
                    
                case .profile:
                    ProfileView(
                        store: store.scope(
                            state: \.profile,
                            action: \.profile
                        )
                    )
                    .navigationBarHidden(true) // 네비게이션 바 숨기기
                }
            },
            destination: { destination in
                // 각 네비게이션 목적지에 맞는 뷰 반환
                switch destination {
                    
                //MARK: FEED
                case let .feedDetail(post):
                    FeedDetailView(
                        post: post,
                        store: store.scope(
                            state: \.feed,
                            action:\.feed
                        )
                    )
                    .toolbar(.hidden, for: .tabBar)
                    
                //MARK: INSIGHT
    
                    
                    
                //MARK: PROFILE
                case let .profileFeedDetail(post):
                    FeedDetailView(
                        post: post,
                        store: store.scope(
                            state: \.feed,
                            action:\.feed
                        )
                    )
                    .toolbar(.hidden, for: .tabBar)
                    
                //MARK: COMMON
                case .settings:
                    Text("커스텀 화면: ")
//                    SettingsView()
                    
                    
                case let .profile(user):
                    ProfileView(
                        store: store.scope(
                            state: \.profile,
                            action: \.profile
                        )
                    )
                   
                    
                case let .custom(name):
                    Text("커스텀 화면: \(name)")
                    
                    // 커스텀 뒤로 가기 동작 예시
//                    Text("특별한 화면")
//                        .withNavigation(store: store, onBack: {
//                            // 뒤로 가기 전에 특별한 로직 실행
//                            saveData()
//                            showConfirmation()
//                            // 그 후 네비게이션 액션 직접 발송도 가능
//                            ViewStore(store).send(.pop)
//                        })
                }
            }
        )
        
    }
}

#Preview {
    AppView(
        store: Store(
            initialState: AppFeature.State(),
            reducer: { AppFeature() }
        )
    )
}
