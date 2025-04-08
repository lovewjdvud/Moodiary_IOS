//
//  NetworkError.swift
//  ourstory
//
//  Created by Songjeongpyeong on 9/2/24.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case invalidURL(message: String = "invalidURL")
    case requestFailed(message: String = "requestFailed",Error)
    case invalidResponse(message: String = "invalidResponse")
    case decodingFailed(message: String = "decodingFailed",Error)
    case unauthorized(message: String = "unauthorized")
    case encodingFailed(message: String = "encodingFailed",Error)
    case timeout(message: String = "timeout")
    case unknown(message: String = "unknown")

    var description: String {
        switch self {
        case .invalidURL(let message),
             .unauthorized(let message),
             .invalidResponse(let message),
             .timeout(let message),
             .unknown(let message):
            return "NetworkError \(message)"

        case .requestFailed(let message,let Error),
             .decodingFailed(let message,let Error),
             .encodingFailed(let message,let Error):
            return "NetworkError \(message) - \(Error.localizedDescription)"
//        case .invalidURL,.unauthorized,.invalidResponse:
//            return ""
        }
    }
}
