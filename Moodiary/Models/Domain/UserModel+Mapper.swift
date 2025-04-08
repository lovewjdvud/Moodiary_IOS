//
//  UserModel+Mapper.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

// Models/Domain/UserModel+Mapper.swift

import Foundation

extension UserModel {
    init(dto: UserResponseDTO) {
        self.id = dto.id
        self.nickname = dto.nickname
        self.bio = dto.bio ?? ""
        self.profileImageURL = URL(string: dto.profileImageURL ?? "")
        self.followerCount = dto.followerCount
        self.followingCount = dto.followingCount
        self.joinedDate = ISO8601DateFormatter().date(from: dto.createdAt) ?? Date()
    }
}
