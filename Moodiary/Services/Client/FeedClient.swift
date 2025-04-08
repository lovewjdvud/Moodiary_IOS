//
//  FeedClient.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 2025/03/30.
//

import Foundation
import ComposableArchitecture
import Dependencies

struct FeedClient {
    var fetchFeed: @Sendable (_ filter: String) async throws -> [PostModel]
    var createPost: @Sendable (_ request: CreatePostRequestModel) async throws -> PostModel
    var updatePost: @Sendable (_ postId: Int, _ request: UpdatePostRequestModel) async throws -> PostModel
    var deletePost: @Sendable (_ postId: Int) async throws -> BaseModelDTO
    var fetchPostDetail: @Sendable (_ postId: Int) async throws -> PostModel
}

extension FeedClient: DependencyKey {
    static let liveValue: Self = {
        let networkManager = NetworkManager(baseURL: Config.baseURL)
        
        return Self(
            
            // 1. 피드 목록 조회
            fetchFeed: { filter in
                let responseDTOs: [PostResponseDTO] = try await networkManager.request(
                    "/feed/list",
                    method: .get,
                    queryItems: [URLQueryItem(name: "filter", value: filter)],
                    requiresAuth: true
                )
                return responseDTOs.map { PostModel(dto: $0) }
            },
            
            // 2. 게시글 작성
            createPost: { request in
                let responseDTO: PostResponseDTO = try await networkManager.request(
                    "/feed/write",
                    method: .post,
                    body: request,
                    requiresAuth: true
                )
                return PostModel(dto: responseDTO)
            },
            
            // 3. 게시글 수정
            updatePost: { postId, request in
                let responseDTO: PostResponseDTO = try await networkManager.request(
                    "/feed/update/\(postId)",
                    method: .put,
                    body: request,
                    requiresAuth: true
                )
                return PostModel(dto: responseDTO)
            },
            
            // 4. 게시글 삭제
            deletePost: { postId in
                try await networkManager.request(
                    "/feed/delete/\(postId)",
                    method: .delete,
                    requiresAuth: true
                )
            },
            
            // 5. 게시글 상세 조회
            fetchPostDetail: { postId in
                let responseDTO: PostResponseDTO = try await networkManager.request(
                    "/feed/detail/\(postId)",
                    method: .get,
                    requiresAuth: true
                )
                return PostModel(dto: responseDTO)
            }
        )
    }()
}

extension DependencyValues {
    var feedClient: FeedClient {
        get { self[FeedClient.self] }
        set { self[FeedClient.self] = newValue }
    }
}
