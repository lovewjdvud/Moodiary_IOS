//
//  UserResponseDTO.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

// Models/DTO/UserResponseDTO.swift

import Foundation

struct UserResponseDTO: Codable {
    let id: Int
    let nickname: String
    let bio: String?
    let profileImageURL: String?
    let followerCount: Int
    let followingCount: Int
    let createdAt: String
}

