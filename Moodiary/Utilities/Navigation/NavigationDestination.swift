//
//  NavigationDestination.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/7/25.
//

import Foundation
import SwiftUI
import ComposableArchitecture

/// Navigation 경로를 관리하기 위한 식별 가능한 타입
public enum NavigationDestination: Hashable, Identifiable {
    // MARK: Feed
    case feedDetail(PostModel)
    
    // MARK: Insight
    case settings
    case profile(User)
    case custom(String)
    
    // MARK: Profile
    
    
    // MARK: common
    
    public var id: Self { self }
    
    public struct User: Hashable, Identifiable {
        public let id: UUID
        public let name: String
        
        public init(id: UUID = UUID(), name: String) {
            self.id = id
            self.name = name
        }
    }
}
