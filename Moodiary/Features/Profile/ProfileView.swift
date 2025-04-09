//
//  FeedView.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

import SwiftUI
import ComposableArchitecture
// Profile View
struct ProfileView: View {
    let store: StoreOf<ProfileFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            //            Text("ProfileView")
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("JP")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "gearshape")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Profile Info
                    HStack(alignment: .top, spacing: 20) {
                        // Profile Image
                        if let profileURL = viewStore.user?.profileImageURL {
                            AsyncImage(url: profileURL) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } placeholder: {
                                Image(systemName: viewStore.profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .foregroundColor(.gray)
                            }
                        } else {
                            Image(systemName: viewStore.profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .foregroundColor(.gray)
                        }
                        
                        // Stats
                        HStack(spacing: 20) {
                            VStack {
                                Text("5")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Posts")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack {
                                Text("\(viewStore.followers)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Followers")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack {
                                Text("\(viewStore.following)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Following")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Bio
                    VStack(alignment: .leading, spacing: 4) {
                        Text("displayName")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("viewStore.bio")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Edit Profile Button
                    Button(action: { viewStore.send(.editProfileTapped) }) {
                        Text("Edit Profile")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.black)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Tab Bar
                    HStack(spacing: 0) {
                        Button(action: { viewStore.send(.selectTab(.posts)) }) {
                            VStack {
                                Image(systemName: "square.grid.2x2")
                                    .font(.system(size: 22))
                                    .foregroundColor(viewStore.selectedTab == .posts ? .white : .gray)
                                
                                if viewStore.selectedTab == .posts {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.white)
                                        .padding(.top, 5)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button(action: { viewStore.send(.selectTab(.saved)) }) {
                            VStack {
                                Image(systemName: "bookmark")
                                    .font(.system(size: 22))
                                    .foregroundColor(viewStore.selectedTab == .saved ? .white : .gray)
                                
                                if viewStore.selectedTab == .saved {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.white)
                                        .padding(.top, 5)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button(action: { viewStore.send(.selectTab(.liked)) }) {
                            VStack {
                                Image(systemName: "heart")
                                    .font(.system(size: 22))
                                    .foregroundColor(viewStore.selectedTab == .liked ? .white : .gray)
                                
                                if viewStore.selectedTab == .liked {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.white)
                                        .padding(.top, 5)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 15)
                    .padding(.bottom, 5)
                    
                    // Post Grid
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 1),
                            GridItem(.flexible(), spacing: 1),
                            GridItem(.flexible(), spacing: 1)
                        ], spacing: 1) {
                            // Show different posts based on selected tab
                            ForEach(getMoodPosts(for: viewStore.selectedTab), id: \.id) { post in
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("post.mood")
                                        .font(.caption)
                                        .foregroundColor(.purple)
                                    
                                    Text("post.titl")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .lineLimit(3)
                                    
                                    Spacer()
                                    
                                    Text("post.category")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                .padding(8)
                                .frame(height: UIScreen.main.bounds.width / 3)
                                .background(Color(white: 0.15))
                            }
                        }
                    }
                }
            }
        }
    }
}
    // Helper method to get the appropriate posts based on selected tab
    private func getMoodPosts(for tab: ProfileFeature.ProfileTab) -> [MoodPosts] {
        // This would normally come from your store
        let samplePosts = [
            MoodPosts(id: UUID(), title: "A day of reflection", mood: "Thoughtful", category: "Personal", timestamp: Date()),
            MoodPosts(id: UUID(), title: "New job opportunity!", mood: "Excited", category: "Career", timestamp: Date()),
            MoodPosts(id: UUID(), title: "Coffee with old friends", mood: "Nostalgic", category: "Friends", timestamp: Date()),
            MoodPosts(id: UUID(), title: "Finished reading that book", mood: "Accomplished", category: "Personal", timestamp: Date()),
            MoodPosts(id: UUID(), title: "Rainy day thoughts", mood: "Melancholic", category: "Personal", timestamp: Date()),
            MoodPosts(id: UUID(), title: "Workout milestone achieved", mood: "Proud", category: "Health", timestamp: Date()),
            MoodPosts(id: UUID(), title: "Family dinner drama", mood: "Frustrated", category: "Family", timestamp: Date()),
            MoodPosts(id: UUID(), title: "Planning my next trip", mood: "Eager", category: "Travel", timestamp: Date()),
            MoodPosts(id: UUID(), title: "Learning to let go", mood: "Peaceful", category: "Personal", timestamp: Date())
        ]
        
        switch tab {
        case .posts:
            return samplePosts
        case .saved:
            return Array(samplePosts.prefix(4))
        case .liked:
            return Array(samplePosts.suffix(5))
        
    }
}

import Foundation

struct MoodPosts: Identifiable, Equatable {
    let id: UUID
    let title: String
    let mood: String
    let category: String
    let timestamp: Date
    
    // 날짜 포맷팅을 위한 computed property
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    // 샘플 데이터 생성을 위한 static 메서드
    static func createSamplePosts() -> [MoodPosts] {
        return [
            MoodPosts(id: UUID(), title: "A day of reflection", mood: "Thoughtful", category: "Personal", timestamp: Date()),
            MoodPosts(id: UUID(), title: "New job opportunity!", mood: "Excited", category: "Career", timestamp: Date()),
            MoodPosts(id: UUID(), title: "Coffee with old friends", mood: "Nostalgic", category: "Friends", timestamp: Date()),
            MoodPosts(id: UUID(), title: "Finished reading that book", mood: "Accomplished", category: "Personal", timestamp: Date()),
            MoodPosts(id: UUID(), title: "Rainy day thoughts", mood: "Melancholic", category: "Personal", timestamp: Date()),
            MoodPosts(id: UUID(), title: "Workout milestone achieved", mood: "Proud", category: "Health", timestamp: Date()),
            MoodPosts(id: UUID(), title: "Family dinner drama", mood: "Frustrated", category: "Family", timestamp: Date()),
            MoodPosts(id: UUID(), title: "Planning my next trip", mood: "Eager", category: "Travel", timestamp: Date()),
            MoodPosts(id: UUID(), title: "Learning to let go", mood: "Peaceful", category: "Personal", timestamp: Date())
        ]
    }
}

// Codable 지원이 필요한 경우를 위한 확장
extension MoodPosts: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case mood
        case category
        case timestamp
    }
}
