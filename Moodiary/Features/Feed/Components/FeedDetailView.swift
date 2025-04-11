//
//  FeedDetailView.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/8/25.
//

import SwiftUI
import ComposableArchitecture


struct FeedDetailView: View {
    @State var post: PostModel
    let store: StoreOf<FeedFeature>
    @State private var isLiked: Bool = false
    @State private var commentText: String = ""
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // 상단 네비게이션 바
                    CustomNavigationBar(
                        title: "Post Details",
                        onBack: {
                            // 뒤로 가기 로직
                            viewStore.send(.feedBackButtonTapped)
                        },
                        onMore: {
                            // 더보기 옵션 로직
                           
                        }
                    )
                    
                    // 스크롤 뷰로 내용 표시
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            // 포스트 헤더
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                                
                                VStack(alignment: .leading) {
                                    Text(post.nickname)
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    
                                    Text("1시간")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }
                                
                                Spacer()
                                
                                Text("카테고리 들어가는 자리")
                                    .foregroundColor(.purple)
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.purple.opacity(0.2))
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                            
                            // 무드 및 내용
                            VStack(alignment: .leading, spacing: 10) {
                                Text("무드")
                                    .foregroundColor(.purple)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                Text(post.content)
                                    .foregroundColor(.white)
                                    .font(.body)
                            }
                            .padding(.horizontal)
                            
                            // 좋아요 및 댓글 섹션
                            HStack {
                                Button(action: {
                                    isLiked.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: isLiked ? "heart.fill" : "heart")
                                            .foregroundColor(isLiked ? .red : .white)
                                        Text("\(post.likeCount)")
                                            .foregroundColor(.white)
                                    }
                                }
                                
                                Button(action: {
                                    // 댓글 포커스 로직
                                }) {
                                    HStack {
                                        Image(systemName: "message")
                                            .foregroundColor(.white)
                                        Text("\("댓글")")
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.leading)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            
                            // 댓글 섹션
                            Text("Comments")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding(.horizontal)
                            
                            //                        // 댓글 리스트
                            //                        ForEach(post.commentList, id: \.id) { comment in
                            //                            CommentView(comment: comment)
                            //                        }
                            //                        
                            Spacer()
                        }
                    }
                    
                    // 댓글 입력 영역
                    HStack {
                        TextField("Write a comment...", text: $commentText)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color(white: 0.2))
                            .cornerRadius(20)
                        
                        Button(action: {
                            guard !commentText.isEmpty else { return }
                            
                            let newComment = Comment(
                                id: UUID(),
                                username: "Current User", // 실제 사용자 이름으로 대체
                                content: commentText,
                                timestamp: Date().formatRelativeTime()
                            )
                            //                        
                            //                        post.commentList.append(newComment)
                            commentText = ""
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.purple)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true) // 네비게이션 바 숨기기
            .onAppear{
                print("dddd")
                hideTabBar()
            }
        }
    }
}

// 댓글 뷰
struct CommentView: View {
    let comment: Comment
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(comment.username)
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(comment.timestamp)
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                
                Text(comment.content)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

// 데이터 모델
struct MoodPost: Identifiable, Equatable {
    let id: UUID
    let username: String
    let mood: String
    let content: String
    let category: String
    let timestamp: String
    var likes: Int
    var comments: Int
    var commentList: [Comment]
}

struct Comment: Identifiable, Equatable {
    let id: UUID
    let username: String
    let content: String
    let timestamp: String
}

// 날짜 포맷 확장
extension Date {
    func formatRelativeTime() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}


// 더미 데이터 확장
extension MoodPost {
    // 샘플 포스트 생성 메서드
    static func createSamplePosts() -> [MoodPost] {
        return [
            MoodPost(
                id: UUID(),
                username: "Emma Thompson",
                mood: "Feeling Inspired",
                content: "Today, I realized that every small step counts towards my big dreams. Keep pushing forward, even when it feels tough.",
                category: "Career",
                timestamp: "2h ago",
                likes: 42,
                comments: 5,
                commentList: [
                    Comment(
                        id: UUID(),
                        username: "Alex Rodriguez",
                        content: "Your words are so motivating! Keep going!",
                        timestamp: "1h ago"
                    ),
                    Comment(
                        id: UUID(),
                        username: "Sophie Lee",
                        content: "I needed to hear this today. Thank you for sharing.",
                        timestamp: "30m ago"
                    )
                ]
            ),
            MoodPost(
                id: UUID(),
                username: "Michael Chen",
                mood: "Feeling Anxious",
                content: "Struggling with self-doubt today. The pressure of expectations is overwhelming. Trying to remind myself that it's okay to not be okay.",
                category: "Personal",
                timestamp: "5h ago",
                likes: 27,
                comments: 8,
                commentList: [
                    Comment(
                        id: UUID(),
                        username: "Liam Park",
                        content: "You're not alone. Reach out if you need to talk.",
                        timestamp: "4h ago"
                    ),
                    Comment(
                        id: UUID(),
                        username: "Olivia Kim",
                        content: "Sending positive vibes your way. You've got this!",
                        timestamp: "3h ago"
                    )
                ]
            ),
            MoodPost(
                id: UUID(),
                username: "Sarah Johnson",
                mood: "Feeling Excited",
                content: "Just landed my dream job at a tech startup! Years of hard work and persistence have finally paid off. Dreams do come true!",
                category: "Career",
                timestamp: "1d ago",
                likes: 156,
                comments: 22,
                commentList: [
                    Comment(
                        id: UUID(),
                        username: "David Wong",
                        content: "Congratulations! Your hard work has truly inspired me.",
                        timestamp: "22h ago"
                    ),
                    Comment(
                        id: UUID(),
                        username: "Rachel Green",
                        content: "This is amazing news! So proud of you!",
                        timestamp: "20h ago"
                    )
                ]
            ),
            MoodPost(
                id: UUID(),
                username: "Ryan Martinez",
                mood: "Feeling Heartbroken",
                content: "Sometimes love isn't enough. Learning to let go and find peace within myself. It hurts, but I know I'll grow from this.",
                category: "Love",
                timestamp: "3d ago",
                likes: 34,
                comments: 12,
                commentList: [
                    Comment(
                        id: UUID(),
                        username: "Jessica Lee",
                        content: "Healing takes time. Be kind to yourself.",
                        timestamp: "2d ago"
                    ),
                    Comment(
                        id: UUID(),
                        username: "Tom Harris",
                        content: "You're stronger than you know. Stay positive.",
                        timestamp: "1d ago"
                    )
                ]
            ),
            MoodPost(
                id: UUID(),
                username: "Emily Wu",
                mood: "Feeling Grateful",
                content: "Spent the day with my closest friends. Grateful for these connections that make life beautiful. True friendship is a treasure.",
                category: "Friends",
                timestamp: "6h ago",
                likes: 78,
                comments: 15,
                commentList: [
                    Comment(
                        id: UUID(),
                        username: "Chris Taylor",
                        content: "Friendship goals! Love seeing this.",
                        timestamp: "5h ago"
                    ),
                    Comment(
                        id: UUID(),
                        username: "Anna Rodriguez",
                        content: "Cherish these moments. They're priceless.",
                        timestamp: "4h ago"
                    )
                ]
            )
        ]
    }
}
