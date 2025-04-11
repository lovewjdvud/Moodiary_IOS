//
//  TabBarVisibilityManager.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 4/11/25.
//

import Foundation
import UIKit

func hideTabBar() {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let tabBarController = windowScene.windows.first?.rootViewController as? UITabBarController {
        tabBarController.tabBar.isHidden = true
    }
}

func showTabBar() {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let tabBarController = windowScene.windows.first?.rootViewController as? UITabBarController {
        tabBarController.tabBar.isHidden = false
    }
}
