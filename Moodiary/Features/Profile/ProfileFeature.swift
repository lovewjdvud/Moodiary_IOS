//
//  ProfileFeature.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 2025/03/30.
//

import Foundation
import ComposableArchitecture
import SwiftUI



struct ProfileFeature: Reducer {

    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var user: UserModel?
        var myPosts: [PostModel] = []
        var followers: [UserModel] = []
        var following: [UserModel] = []
        var profileImage: String = "person.circle.fill" // 기본 시스템 이미지
        var selectedTab: ProfileTab = .posts // 기본값을 .posts로 설정
        var isLoading: Bool = false
        var errorMessage: String?
    }

    // MARK: - Action
    @CasePathable
    @dynamicMemberLookup
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)

        case onAppear

        case fetchProfile
        case fetchProfileSuccess(UserModel)
        case fetchProfileFailure(String)

        case fetchMyPosts
        case fetchMyPostsSuccess([PostModel])
        case fetchMyPostsFailure(String)

        case fetchFollowers
        case fetchFollowersSuccess([UserModel])
        case fetchFollowersFailure(String)

        case fetchFollowings
        case fetchFollowingsSuccess([UserModel])
        case fetchFollowingsFailure(String)

        case cancelFail(CancelID, String)

        case selectTab(ProfileTab)
        case editProfileTapped
    }

        enum ProfileTab: Equatable {
        case posts
        case saved
        case liked
    }

    

    enum CancelID {
        case fetchProfile
        case fetchMyPosts
        case fetchFollowers
        case fetchFollowings
    }

    // MARK: - Dependencies
    @Dependency(\.profileClient) var profileClient

    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            // MARK: 뷰 바인딩
            case .binding:
                return .none

            // MARK: 초기 진입
            case .onAppear:
                return .merge([
                    .send(.fetchProfile),
                    .send(.fetchMyPosts)
                ])

            // MARK: 프로필 조회
            case .fetchProfile:
                state.isLoading = true
                return .run { send in
                    do {
                        let userId = AuthManager.shared.getUserId() ?? 0
                        let user = try await profileClient.fetchUserProfile(userId)
                        await send(.fetchProfileSuccess(user))
                    } catch {
                        await send(.fetchProfileFailure("프로필을 불러오지 못했습니다."))
                        await send(.cancelFail(.fetchProfile, error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.fetchProfile)

            case .fetchProfileSuccess(let user):
                state.user = user
                state.isLoading = false
                return .none

            case .fetchProfileFailure(let message):
                state.errorMessage = message
                state.isLoading = false
                return .none

            // MARK: 내가 쓴 글 조회
            case .fetchMyPosts:
                return .run { send in
                    do {
                        let posts = try await profileClient.fetchMyPosts()
                        await send(.fetchMyPostsSuccess(posts))
                    } catch {
                        await send(.fetchMyPostsFailure("내 글을 불러오지 못했습니다."))
                        await send(.cancelFail(.fetchMyPosts, error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.fetchMyPosts)

            case .fetchMyPostsSuccess(let posts):
                state.myPosts = posts
                return .none

            case .fetchMyPostsFailure(let message):
                state.errorMessage = message
                return .none

            // MARK: 팔로워 조회
            case .fetchFollowers:
                guard let userId = state.user?.id else { return .none }
                return .run { send in
                    do {
                        let list = try await profileClient.fetchFollowers(userId)
                        await send(.fetchFollowersSuccess(list))
                    } catch {
                        await send(.fetchFollowersFailure("팔로워를 불러오지 못했습니다."))
                        await send(.cancelFail(.fetchFollowers, error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.fetchFollowers)

            case .fetchFollowersSuccess(let users):
                state.followers = users
                return .none

            case .fetchFollowersFailure(let message):
                state.errorMessage = message
                return .none

            // MARK: 팔로잉 조회
            case .fetchFollowings:
                guard let userId = state.user?.id else { return .none }
                return .run { send in
                    do {
                        let list = try await profileClient.fetchFollowings(userId)
                        await send(.fetchFollowingsSuccess(list))
                    } catch {
                        await send(.fetchFollowingsFailure("팔로잉을 불러오지 못했습니다."))
                        await send(.cancelFail(.fetchFollowings, error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.fetchFollowings)

            case .fetchFollowingsSuccess(let users):
                state.following = users
                return .none

            case .fetchFollowingsFailure(let message):
                state.errorMessage = message
                return .none

            // MARK: 실패/취소 핸들링
            case .cancelFail(let id, let msg):
                print("❌ ProfileFeature CancelFail [\(id)]: \(msg)")
                return .cancel(id: id)

            case let .selectTab(tab):
                state.selectedTab = tab
                return .none
            
            case .editProfileTapped:
                // Handle edit profile action
                return .none
            }
        }
    }
}
