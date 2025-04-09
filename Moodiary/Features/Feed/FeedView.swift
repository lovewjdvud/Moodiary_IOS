//
//  FeedView.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

import SwiftUI
import ComposableArchitecture

struct FeedView: View {
    let store: StoreOf<FeedFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // 팔로워/전체 토글
                    HStack {
                        Button(action: { viewStore.send(.selectFeedFilter(.following)) }) {
                            MDTextView(text: "Following",
                                     size: 16,
                                     style: .bold,
                                     color: viewStore.selectedFilter == .following ? .white : .gray)
                        }
                        
                        Button(action: { viewStore.send(.selectFeedFilter(.all)) }) {
                            MDTextView(text: "All",
                                     size: 16,
                                     style: .bold,
                                     color: viewStore.selectedFilter == .all ? .white : .gray)
                        }
                    }
                    .padding()
                    .background(Color.black)
                    
                    // 카테고리 선택기
                    FeedCategorySelector(
                        selectedCategory: viewStore.binding(
                            get: \.selectedCategory,
                            send: { .setCategory($0) }
                        )
                    )
                    
                    // 피드 리스트
                    FeedList(
                        posts: viewStore.feedList,
                        onDeletePost: { postId in
                            viewStore.send(.deletePost(id: postId))
                        }
                    )
                }
            }
            .onAppear {
                viewStore.send(.fetchFeed(viewStore.selectedFilter))
            }
        }
    }
}

//struct MoodPostCard: View {
//    let username: String
//    let mood: String
//    let content: String
//    let category: String
//    let timestamp: String
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            HStack {
//                MDTextView(text: username,
//                          size: 16,
//                          style: .semiBold,
//                          color: .white)
//                
//                Spacer()
//                
//                MDTextView(text: category,
//                          size: 12,
//                          style: .regular,
//                          color: .gray)
//            }
//            
//            MDTextView(text: mood,
//                      size: 16,
//                      style: .semiBold,
//                      color: .purple)
//            
//            MDTextView(text: content,
//                      size: 14,
//                      style: .regular,
//                      color: .white,
//                      maxLines: 3)
//            
//            HStack {
//                Spacer()
//                MDTextView(text: timestamp,
//                          size: 12,
//                          style: .regular,
//                          color: .gray)
//            }
//        }
//        .padding()
//        .background(Color(white: 0.2))
//        .cornerRadius(15)
//    }
//}
////
//#Preview {
//    FeedView(
//        store: Store(initialState: FeedFeature.State()) {
//            FeedFeature()
//        })
//}
//


//struct FeedView: View {
//    let store: StoreOf<FeedFeature>
//    let samplePosts = MoodPost.createSamplePosts()
//    let asdsad =  MoodPost(
//        id: UUID(),
//        username: "Emma Thompson",
//        mood: "Feeling Inspired",
//        content: "Today, I realized that every small step counts towards my big dreams. Keep pushing forward, even when it feels tough.",
//        category: "Career",
//        timestamp: "2h ago",
//        likes: 42,
//        comments: 5,
//        commentList: [
//            Comment(
//                id: UUID(),
//                username: "Alex Rodriguez",
//                content: "Your words are so motivating! Keep going!",
//                timestamp: "1h ago"
//            ),
//            Comment(
//                id: UUID(),
//                username: "Sophie Lee",
//                content: "I needed to hear this today. Thank you for sharing.",
//                timestamp: "30m ago"
//            )
//        ]
//    )
//    var body: some View {
//        
//        WithViewStore(self.store, observe: { $0 }) { viewStore in
//            FeedDetailView(post:asdsad )
//        }
//    }
//}
