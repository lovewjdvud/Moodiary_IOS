//
//  ProfileClient.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 2025/03/30.
//

import Foundation
import ComposableArchitecture
import Dependencies
import UIKit

struct ProfileClient {
    var fetchUserProfile: @Sendable (_ userId: Int) async throws -> UserModel
    var updateUserProfile: @Sendable (_ request: UserProfileUpdateRequestModel) async throws -> UserModel
    var uploadProfileImage: @Sendable (_ imageData: Data) async throws -> ImageUploadResponseDTO
    var deleteProfileImage: @Sendable (_ imageId: Int) async throws -> BaseModelDTO
    var fetchMyPosts: @Sendable () async throws -> [PostModel]
    var follow: @Sendable (_ userId: Int) async throws -> BaseModelDTO
    var unfollow: @Sendable (_ userId: Int) async throws -> BaseModelDTO
    var fetchFollowers: @Sendable (_ userId: Int) async throws -> [UserModel]
    var fetchFollowings: @Sendable (_ userId: Int) async throws -> [UserModel]
}

extension ProfileClient: DependencyKey {
    static let liveValue: Self = {
        let networkManager = NetworkManager(baseURL: Config.baseURL)

        return Self(
            
            // 1. 유저 프로필 조회
            fetchUserProfile: { userId in
                let dto: UserResponseDTO = try await networkManager.request(
                    "/user/info/\(userId)",
                    method: .get,
                    requiresAuth: true
                )
                return UserModel(dto: dto)
            },

            // 2. 프로필 수정
            updateUserProfile: { request in
                let dto: UserResponseDTO = try await networkManager.request(
                    "/user/info/update/\(request.id)",
                    method: .put,
                    body: request,
                    requiresAuth: true
                )
                return UserModel(dto: dto)
            },

            // 3. 프로필 이미지 업로드
            uploadProfileImage: { imageData in
                let parameters: [String: String] = [:] // 필요 시 추가
                let fileData: [String: (data: Data, fileName: String, mimeType: String)] = [
                    "file": (data: imageData, fileName: "profile.jpg", mimeType: "image/jpeg")
                ]
                return try await networkManager.uploadMultipartFormData(
                    "/user/image",
                    parameters: parameters,
                    fileData: fileData,
                    requiresAuth: true
                )
            },

            // 4. 프로필 이미지 삭제
            deleteProfileImage: { imageId in
                try await networkManager.request(
                    "/user/image/\(imageId)",
                    method: .delete,
                    requiresAuth: true
                )
            },

            // 5. 내가 쓴 글 목록 조회
            fetchMyPosts: {
                let dtos: [PostResponseDTO] = try await networkManager.request(
                    "/feed/my",
                    method: .get,
                    requiresAuth: true
                )
                return dtos.map { PostModel(dto: $0) }
            },

            // 6. 팔로우
            follow: { userId in
                try await networkManager.request(
                    "/user/follow/\(userId)",
                    method: .post,
                    requiresAuth: true
                )
            },

            // 7. 언팔로우
            unfollow: { userId in
                try await networkManager.request(
                    "/user/unfollow/\(userId)",
                    method: .delete,
                    requiresAuth: true
                )
            },

            // 8. 팔로워 목록 조회
            fetchFollowers: { userId in
                let dtos: [UserResponseDTO] = try await networkManager.request(
                    "/user/followers/\(userId)",
                    method: .get,
                    requiresAuth: true
                )
                return dtos.map { UserModel(dto: $0) }
            },

            // 9. 팔로잉 목록 조회
            fetchFollowings: { userId in
                let dtos: [UserResponseDTO] = try await networkManager.request(
                    "/user/followings/\(userId)",
                    method: .get,
                    requiresAuth: true
                )
                return dtos.map { UserModel(dto: $0) }
            }
        )
    }()
}

extension DependencyValues {
    var profileClient: ProfileClient {
        get { self[ProfileClient.self] }
        set { self[ProfileClient.self] = newValue }
    }
}
