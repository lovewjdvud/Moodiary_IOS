//
//  BaseModel.swift
//  ourstory
//
//  Created by Songjeongpyeong on 9/4/24.
//

import Foundation
struct BaseModelDTO: Codable, Equatable {
    let result_cd: Int
    var result_msg: String?
    var detail_msg: String?
    var exception : ExceptionModel?

}

struct ExceptionModel: Codable, Equatable {
     let errorCode: Int?
     var errorMessage: String?

}
