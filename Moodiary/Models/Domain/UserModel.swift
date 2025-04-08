//
//  UserModel.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

// Models/Domain/UserModel.swift

import Foundation

struct UserModel: Identifiable, Equatable {
    let id: Int
    let nickname: String
    let bio: String
    let profileImageURL: URL?
    let followerCount: Int
    let followingCount: Int
    let joinedDate: Date
}

