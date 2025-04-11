//
//  MoodPostCard.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/9/25.
//

import SwiftUI
import ComposableArchitecture
struct FeedCellView: View {
    let username: String
    let mood: String
    let content: String
    let category: String
    let timestamp: String
    let store: StoreOf<FeedFeature>
    let post : PostModel
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    MDTextView(text: username,
                               size: 1,
                               style: .bold,
                               color: .purple)
                    
                    Spacer()
                    
                    MDTextView(text: category,
                               size: 12,
                               style: .regular,
                               color: .gray)
                }
                
                MDTextView(text: mood,
                           size: 16,
                           style: .semiBold,
                           color: .purple)
                
                Button(action: { viewStore.send(.feedTapped(post)) }) {
                    MDTextView(text: content,
                               size: 14,
                               style: .regular,
                               color: .white,
                               maxLines: 3)
                    
                }
                
                HStack {
                    Spacer()
                    MDTextView(text: timestamp,
                               size: 12,
                               style: .regular,
                               color: .gray)
                }
            }
            .padding()
            .background(Color(white: 0.2))
            .cornerRadius(15)
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
//                Text(username)
//                    .font(.headline)
//                    .foregroundColor(.white)
//                
//                Spacer()
//                
//                Text(category)
//                    .foregroundColor(.gray)
//                    .font(.caption)
//            }
//            
//            Text(mood)
//                .foregroundColor(.purple)
//                .fontWeight(.semibold)
//            
//            Text(content)
//                .foregroundColor(.white)
//            
//            HStack {
//                Spacer()
//                Text(timestamp)
//                    .foregroundColor(.gray)
//                    .font(.caption)
//            }
//        }
//        .padding()
//        .background(Color(white: 0.2))
//        .cornerRadius(15)
//    }
//}
