//
//  FeedCategorySelector.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/9/25.
//

import SwiftUI

enum FeedCategory: String, CaseIterable {
    case all = "All"
    case work = "Work"
    case love = "Love"
    case career = "Career"
    case friends = "Friends"
}

struct FeedCategorySelector: View {
    @Binding var selectedCategory: FeedCategory
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(FeedCategory.allCases, id: \.self) { category in
                    Button(action: { selectedCategory = category }) {
                        MDTextView(text: category.rawValue,
                                 size: 14,
                                 style: .medium,
                                 color: selectedCategory == category ? .white : .gray)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background(selectedCategory == category ? Color.purple : Color.clear)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(Color.black)
    }
}

#Preview {
    FeedCategorySelector(selectedCategory: .constant(.all))
}
