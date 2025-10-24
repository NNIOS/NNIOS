//
//  DK25CompatibilityHelper.swift
//  Neighbrsnooks
//
//  Created by Irshad Malik on 23/10/25.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift


class SDK25CompatibilityHelper {

    /// Call this in AppDelegate -> didFinishLaunchingWithOptions
    @MainActor static func enableOldBehavior(window: UIWindow?) {

        
        // 2️⃣ Tab Bar - keep old tint color
        if let tabBar = window?.rootViewController as? UITabBarController {
            tabBar.tabBar.tintColor = UIColor.systemBlue
            tabBar.tabBar.unselectedItemTintColor = .gray
        }

        // 3️⃣ Alerts / UIAlertController
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.systemBlue

        // 4️⃣ Force Light Mode (optional)
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

        // 5️⃣ ScrollView / Layout
        UIScrollView.appearance().contentInsetAdjustmentBehavior = .never

        print("✅ SDK 25 Compatibility Mode Enabled")
    }
}
