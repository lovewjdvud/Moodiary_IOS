//
//  FontUtils.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

import Foundation
import SwiftUI

class FontUtils {
    
    public static func resizedFont(_ fontSize: CGFloat, _ destSize: CGFloat? = nil) -> CGFloat {
        var screenSize = UIScreen.main.bounds.width
        if let destSize = destSize {
            screenSize = destSize
        }
        let ratio = screenSize / 375.0
        return ratio * fontSize
    }
    
}

