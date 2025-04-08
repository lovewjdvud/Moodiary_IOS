//
//  UpdatePostRequestModel.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

import Foundation

struct UpdatePostRequestModel: Encodable {
    let content: String
    let emotion: String
    let productivity: Int
    let tags: [String]
}

