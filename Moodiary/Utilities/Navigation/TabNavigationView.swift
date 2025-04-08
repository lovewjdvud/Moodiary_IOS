//
//  TabNavigationView.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/7/25.
//

import Foundation
import SwiftUI
import ComposableArchitecture

/// TabView와 NavigationStack을 결합한 View
public struct TabNavigationView<TabContent: View, Destination: View>: View {
    let store: StoreOf<NavigationFeature>
    let tabContent: (NavigationFeature.State.Tab) -> TabContent
    let destination: (NavigationDestination) -> Destination
    
    public init(
        store: StoreOf<NavigationFeature>,
        @ViewBuilder tabContent: @escaping (NavigationFeature.State.Tab) -> TabContent,
        @ViewBuilder destination: @escaping (NavigationDestination) -> Destination
    ) {
        self.store = store
        self.tabContent = tabContent
        self.destination = destination
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            TabView(selection: viewStore.binding(
                get: \.currentSelectedTab,
                send: NavigationFeature.Action.selectTab
            )) {
                ForEach([
                    NavigationFeature.State.Tab.feed,
                    .insight,
                    .profile
                ], id: \.self) { tab in
                    NavigationStack(path: viewStore.binding(
                        get: \.path,
                        send: { _ in .navigateToRoot }
                    )) {
                        tabContent(tab)
                            .navigationDestination(for: NavigationDestination.self) { destination in
                                self.destination(destination)
                            }
                    }
                    .tabItem {
                        Label(tab.title, systemImage: tab.iconName)
                    }
                    .tag(tab)
                }
            }
        }
    }
}
