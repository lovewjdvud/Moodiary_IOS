//
//  FeedFeature.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 2025/03/30.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct FeedFeature: Reducer {

    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var feedList: [PostModel] = []
        var selectedFilter: FeedFilterType = .all
        var isWritePresented: Bool = false
        var isEditPresented: Bool = false
        var isLoading: Bool = false
        var errorMessage: String?
    }

    // MARK: - Action
    @CasePathable
    @dynamicMemberLookup
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)

        case fetchFeed(FeedFilterType)
        case fetchFeedSuccess([PostModel])
        case fetchFeedFailure(String)

        case deletePost(id: Int)
        case deletePostSuccess(id: Int)
        case deletePostFailure(String)

        case writeButtonTapped
        case editButtonTapped
        case dismissWrite
        case selectFeedFilter(FeedFilterType)

        case cancelFail(CancelID, String)
    }

    // MARK: - Dependency
    @Dependency(\.feedClient) var feedClient

    // MARK: - Cancel ID
    enum CancelID {
        case fetchFeed
        case deletePost
    }

    // MARK: - 필터 타입
    enum FeedFilterType: String, CaseIterable, Equatable {
        case all = "전체"
        case following = "팔로잉"
    }

    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            // 바인딩
            case .binding:
                return .none

            // 피드 필터 선택
            case .selectFeedFilter(let filter):
                state.selectedFilter = filter
                return .send(.fetchFeed(filter))

            // 글쓰기 / 수정 화면 제어
            case .writeButtonTapped:
                state.isWritePresented = true
                return .none

            case .editButtonTapped:
                state.isEditPresented = true
                return .none

            case .dismissWrite:
                state.isWritePresented = false
                state.isEditPresented = false
                return .none

            // 피드 조회
            case .fetchFeed(let filter):
                state.isLoading = true
                state.errorMessage = nil
                return .run { send in
                    do {
                        let posts = try await feedClient.fetchFeed(filter.rawValue)
                        await send(.fetchFeedSuccess(posts))
                    } catch {
                        await send(.fetchFeedFailure("피드를 불러오지 못했습니다."))
                        await send(.cancelFail(.fetchFeed, error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.fetchFeed)

            case .fetchFeedSuccess(let posts):
                state.feedList = posts
                state.isLoading = false
                return .none

            case .fetchFeedFailure(let errorMessage):
                state.feedList = []
                state.isLoading = false
                state.errorMessage = errorMessage
                return .none

            // 게시글 삭제
            case .deletePost(let id):
                return .run { send in
                    do {
                        _ = try await feedClient.deletePost(id)
                        await send(.deletePostSuccess(id: id))
                    } catch {
                        await send(.deletePostFailure("삭제에 실패했습니다."))
                        await send(.cancelFail(.deletePost, error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.deletePost)

            case .deletePostSuccess(let id):
                state.feedList.removeAll { $0.id == id }
                return .none

            case .deletePostFailure(let message):
                state.errorMessage = message
                return .none

            case .cancelFail(let id, let msg):
                print("❌ [CancelFail] \(id) - \(msg)")
                return .cancel(id: id)
            }
        }
    }
}
