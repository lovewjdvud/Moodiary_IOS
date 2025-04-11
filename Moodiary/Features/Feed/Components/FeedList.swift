//
//  FeedList.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/9/25.
//

import SwiftUI
import ComposableArchitecture

struct FeedList: View {
    let posts: [PostModel]
    let onDeletePost: (Int) -> Void
    let store: StoreOf<FeedFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List {
                ForEach(PostModel.feedSamplePosts(), id: \.id) { post in
                    FeedCellView(
                        username: post.nickname,
                        mood: post.emotion.rawValue,
                        content: post.content,
                        category: post.tags.first ?? "",
                        timestamp: formatTimestamp(post.createdAt),
                        store: store,
                        post: post
                    )
                    .listRowBackground(Color.black)
                    .listRowSeparator(.hidden)
                    .padding(.bottom, 10)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            onDeletePost(post.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
        }
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
//
//#Preview {
//    FeedList(
//        posts: [
//            PostModel(
//                id: 1,
//                userId: 1,
//                nickname: "John Doe",
//                profileImageURL: nil,
//                content: "Having a great day!",
//                emotion: .happy,
//                productivity: 5,
//                tags: ["Personal"],
//                likeCount: 10,
//                commentCount: 5,
//                createdAt: Date()
//            )
//        ],
//        onDeletePost: { _ in }, store: <#StoreOf<FeedFeature>#>
//    )
//    .background(Color.black)
//}
