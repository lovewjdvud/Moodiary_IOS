//
//  Color.swift
//  ourstory
//
//  Created by Songjeongpyeong on 9/3/24.
//

import SwiftUI
import UIKit
extension Color {
    init(_ rgb: (CGFloat, CGFloat, CGFloat), opacity: CGFloat = 1) {
        self.init(red: rgb.0/255, green: rgb.1/255, blue: rgb.2/255, opacity: opacity)
    }

    static let primaryColor: Color = Color((255, 197, 0))
    static let darkTextColor: Color = Color((80, 80, 80))
    static let textColor: Color = Color((150, 150, 150))
    static let dividerColor: Color = Color((224, 224, 224))
    
    static let mainBackgroundColor: Color = Color(red: 31/255, green: 28/255, blue: 28/255)
    static let mainLightColor: Color = Color(red: 77 / 255, green: 73 / 255, blue: 73 / 255)
    
    //Color(red: 31/255, green: 28/255, blue: 28/255)
    
}
 // #12CB32   아이콘 색
extension UIColor {
    static let mainBackgroundColor = UIColor(red: 31/255, green: 28/255, blue: 28/255, alpha: 1.0)


}
