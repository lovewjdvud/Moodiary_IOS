//
//  View++.swift
//  ourstory
//
//  Created by Songjeongpyeong on 9/11/24.
//


import SwiftUI
import ComposableArchitecture
extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

extension View {
    /// NavigationLink 생성을 위한 편리한 메서드
    public func navigationLink<Content: View>(
        store: StoreOf<NavigationFeature>,
        destination: NavigationDestination,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Button {
                viewStore.send(.navigate(to: destination))
            } label: {
                content()
            }
        }
    }
    
    /// 네비게이션 동작을 위한 메서드 추가
    public func withNavigation(
        store: StoreOf<NavigationFeature>,
        onBack: (() -> Void)? = nil
    ) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            self
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if !viewStore.path.isEmpty {
                            Button {
                                if let onBack = onBack {
                                    onBack()
                                } else {
                                    viewStore.send(.pop)
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                        }
                    }
                }
        }
    }
}
