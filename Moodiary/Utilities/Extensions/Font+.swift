//
//  Font.swift
//  ourstory
//
//  Created by Songjeongpyeong on 9/3/24.
//

import Foundation
import SwiftUI

import SwiftUI

extension Font {
 
    // Pretendard 폰트 추가
    static func pretendardBold(_ size: CGFloat) -> Font {
        .custom("Pretendard-Bold", size: size)
    }
    
    static func pretendardLight(_ size: CGFloat) -> Font {
        .custom("Pretendard-Light", size: size)
    }
    
    static func pretendardMedium(_ size: CGFloat) -> Font {
        .custom("Pretendard-Medium", size: size)
    }
    
    static func pretendardRegular(_ size: CGFloat) -> Font {
        .custom("Pretendard-Regular", size: size)
    }
    
    static func pretendardSemiBold(_ size: CGFloat) -> Font {
        .custom("Pretendard-SemiBold", size: size)
    }
}


// Pretendard-Bold
// Pretendard-Light
// Pretendard-Medium
//Pretendard-Regular
// Pretendard-SemiBold
