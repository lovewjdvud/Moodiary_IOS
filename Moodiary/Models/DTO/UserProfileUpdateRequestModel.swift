//
//  UserProfileUpdateRequestModel.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

// Models/DTO/UserProfileUpdateRequestModel.swift

import Foundation

struct UserProfileUpdateRequestModel: Encodable {
    let id: Int
    let nickname: String
    let bio: String
}

