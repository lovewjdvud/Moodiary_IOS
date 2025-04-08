//
//  FeedView.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

import SwiftUI
import ComposableArchitecture
struct ProfileView: View {
    let store: StoreOf<ProfileFeature>
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    ProfileView(
        store: Store(initialState: ProfileFeature.State()) {
            ProfileFeature()
        })
}
