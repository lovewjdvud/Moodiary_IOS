//
//  AuthManager.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 9/2/24.
//

import Foundation

class AuthManager {
    static let shared = AuthManager()
    
    private let tokenKey = "authToken"
    
    private init() {}
    
    func setToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }

    /// JWT 토큰에서 userId 추출
    func getUserId() -> Int? {
        guard let token = getToken() else { return nil }
        let segments = token.split(separator: ".")

        // JWT 구조: header.payload.signature
        guard segments.count > 1 else { return nil }
        let payloadSegment = segments[1]

        // Base64 디코드
        var payloadString = String(payloadSegment)
        payloadString = payloadString.padding(toLength: ((payloadString.count+3)/4)*4,
                                              withPad: "=", startingAt: 0)

        guard let payloadData = Data(base64Encoded: payloadString),
              let payloadJSON = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any],
              let userId = payloadJSON["id"] as? Int else {
            return nil
        }

        return userId
    }
}
