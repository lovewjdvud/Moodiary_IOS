//
//  PostResponseDTO.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

// 📄 Models/DTO/PostResponseDTO.swift

import Foundation

struct PostResponseDTO: Codable {
    let id: Int
    let userId: Int
    let nickname: String
    let profile_img: String?
    
    let content: String
    let emotion: String
    let productivity: Int
    let tags: [String]
    
    let like_count: Int
    let comment_count: Int
    let created_at: String
}

