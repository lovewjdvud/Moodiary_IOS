//
//  MoodiaryApp.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

import SwiftUI
import ComposableArchitecture
@main
struct MoodiaryApp: App {
    
    let store: StoreOf<AppFeature>
    
    init() {
         self.store = Store(
             initialState: AppFeature.State(),
             reducer: { AppFeature() }
         )
     }

    var body: some Scene {
        WindowGroup {
//            ContentView()
            AppView(store: store)
        }
    }
}
