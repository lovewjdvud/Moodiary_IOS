//
//  CustomNavigationBar.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/11/25.
//

import SwiftUI

// 커스텀 네비게이션 바 컴포넌트
struct CustomNavigationBar: View {
    let title: String
    let onBack: () -> Void
    let onMore: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
            
            Spacer()
            
            Text(title)
                .foregroundColor(.white)
                .font(.headline)
            
            Spacer()
            
            Button(action: onMore) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
        }
        .padding()
    }
}
