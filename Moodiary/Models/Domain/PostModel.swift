//
//  PostModel.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

// 📄 Models/Domain/PostModel+Mapper.swift

import Foundation

// 📄 Models/Domain/PostModel.swift

import Foundation

struct PostModel: Identifiable, Equatable {
    let id: Int
    let userId: Int
    let nickname: String
    let profileImageURL: URL?
    
    let content: String
    let emotion: EmotionType
    let productivity: Int
    let tags: [String]
    
    let likeCount: Int
    let commentCount: Int
    let createdAt: Date
}

// 📄 Models/Domain/EmotionType.swift

enum EmotionType: String, Codable, CaseIterable {
    case happy = "😊"
    case sad = "😢"
    case angry = "😡"
    case calm = "😌"
    case confused = "😕"
    case tired = "🥱"
    case empty = "😶" // 기본값

    init(from raw: String) {
        self = EmotionType(rawValue: raw) ?? .empty
    }
}


extension PostModel {
    init(dto: PostResponseDTO) {
        self.id = dto.id
        self.userId = dto.userId
        self.nickname = dto.nickname
        self.profileImageURL = URL(string: dto.profile_img ?? "")
        self.content = dto.content
        self.emotion = EmotionType(from: dto.emotion)
        self.productivity = dto.productivity
        self.tags = dto.tags
        self.likeCount = dto.like_count
        self.commentCount = dto.comment_count
        self.createdAt = ISO8601DateFormatter().date(from: dto.created_at) ?? Date()
    }
}

