//
//  TabNavigationView.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/7/25.
//

import Foundation
import SwiftUI
import ComposableArchitecture

// MARK: - Navigation View Components

/// 기본 NavigationStack을 제공하는 View
public struct NavigationStackView<Content: View, Destination: View>: View {
    let store: StoreOf<NavigationFeature>
    let content: () -> Content
    let destination: (NavigationDestination) -> Destination
    
    public init(
        store: StoreOf<NavigationFeature>,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder destination: @escaping (NavigationDestination) -> Destination
    ) {
        self.store = store
        self.content = content
        self.destination = destination
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack(path: viewStore.binding(
                get: \.path,
                send: { _ in .navigateToRoot }
            )) {
                content()
                    .navigationDestination(for: NavigationDestination.self) { dest in
                        // 여기서 destination은 클로저 매개변수
                        // dest는 NavigationDestination 타입의 값
                        self.destination(dest)
                    }
            }
        }
    }
}

