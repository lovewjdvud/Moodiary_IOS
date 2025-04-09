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
        var feedList: [PostModel] = [
            PostModel(
                id: 1,
                userId: 101,
                nickname: "김감성",
                profileImageURL: URL(string: "https://i.pravatar.cc/150?img=1"),
                content: "오늘은 정말 행복한 하루였어요! 아침에 일어나서 커피 한잔 마시면서 읽은 책이 너무 좋았고, 점심에는 오랜만에 친구를 만나서 맛있는 파스타를 먹었어요 ☺️",
                emotion: .happy,
                productivity: 8,
                tags: ["일상", "행복"],
                likeCount: 24,
                commentCount: 5,
                createdAt: Date().addingTimeInterval(-3600) // 1시간 전
            ),
            PostModel(
                id: 2,
                userId: 102,
                nickname: "직장인_일기",
                profileImageURL: URL(string: "https://i.pravatar.cc/150?img=2"),
                content: "프로젝트 마감이 다가오는데 걱정이 되네요... 그래도 팀원들과 함께라면 잘 해낼 수 있을 거예요! 화이팅! 💪",
                emotion: .confused,
                productivity: 6,
                tags: ["직장", "프로젝트"],
                likeCount: 15,
                commentCount: 3,
                createdAt: Date().addingTimeInterval(-7200) // 2시간 전
            ),
            PostModel(
                id: 3,
                userId: 103,
                nickname: "운동하는곰",
                profileImageURL: URL(string: "https://i.pravatar.cc/150?img=3"),
                content: "오늘 처음으로 5km 러닝 완주했습니다! 작은 목표부터 하나씩 이뤄나가는 중이에요. 다음 목표는 10km! 🏃‍♂️",
                emotion: .happy,
                productivity: 9,
                tags: ["운동", "러닝"],
                likeCount: 42,
                commentCount: 8,
                createdAt: Date().addingTimeInterval(-14400) // 4시간 전
            ),
            PostModel(
                id: 4,
                userId: 104,
                nickname: "밤하늘별",
                profileImageURL: URL(string: "https://i.pravatar.cc/150?img=4"),
                content: "요즘 들어 자꾸 우울해지는데, 이럴 때일수록 긍정적인 마인드를 가지려고 노력중입니다. 여러분들은 어떻게 극복하시나요?",
                emotion: .sad,
                productivity: 4,
                tags: ["고민", "우울"],
                likeCount: 31,
                commentCount: 12,
                createdAt: Date().addingTimeInterval(-28800) // 8시간 전
            ),
            PostModel(
                id: 5,
                userId: 105,
                nickname: "취미부자",
                profileImageURL: URL(string: "https://i.pravatar.cc/150?img=5"),
                content: "드디어 첫 작품이 완성됐어요! 서툴지만 이렇게 하나씩 만들어가는 재미가 있네요. 취미로 시작한 도예가 이제는 제 삶의 큰 부분이 되어가고 있어요 🎨",
                emotion: .calm,
                productivity: 7,
                tags: ["취미", "도예"],
                likeCount: 56,
                commentCount: 9,
                createdAt: Date().addingTimeInterval(-43200) // 12시간 전
            )
        ]
        var selectedFilter: FeedFilterType = .all
        var selectedCategory: FeedCategory = .all
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
        case setCategory(FeedCategory)

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

            case .setCategory(let category):
                state.selectedCategory = category
                return .send(.fetchFeed(state.selectedFilter))

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
