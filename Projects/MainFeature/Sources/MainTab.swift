//
//  MainTab.swift
//  MainFeature
//
//  Created by gnksbm on 2024/01/09.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

enum MainTab: Int, CaseIterable {
    case home, alarm, settings
    
    var tabItem: UITabBarItem {
        switch self {
        case .home:
            return .init(
                title: "홈",
                image: .init(systemName: "house"),
                tag: rawValue
            )
        case .alarm:
            return .init(
                title: "알람",
                image: .init(systemName: "bell"),
                tag: rawValue
            )
        case .settings:
            return .init(
                title: "설정",
                image: .init(systemName: "gearshape"),
                tag: rawValue
            )
        }
    }
}
