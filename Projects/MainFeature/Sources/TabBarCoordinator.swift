//
//  TabBarCoordinator.swift
//  MainFeature
//
//  Created by gnksbm on 2024/01/08.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

import FeatureDependency
import HomeFeature
import AlarmFeature
import SettingsFeature

public final class TabBarCoordinator: Coordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var navigationController: UINavigationController
    public let coordinatorProvider: CoordinatorProvider
    public var coordinatorType: CoordinatorType = .tab
    
    public init(
        navigationController: UINavigationController,
        coordinatorProvider: CoordinatorProvider
    ) {
        self.navigationController = navigationController
        self.coordinatorProvider = coordinatorProvider
    }
    
    public func start() {
        setupTabBarController()
    }
    
    private func setupTabBarController() {
        let tabBarController = TabBarViewController()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = DesignSystemAsset.gray2.color
        
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = 
        tabBarController.tabBar.standardAppearance
        
        navigationController.setViewControllers(
            [tabBarController], animated: true
        )
        
        let viewControllers = MainTab.allCases.map {
            makeNavigationController(tabKind: $0)
        }
        
        tabBarController.viewControllers = viewControllers
        
    }
    
    private func makeNavigationController(
        tabKind: MainTab
    ) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = tabKind.tabItem
        setupChildCoordinators(
            tabKind: tabKind,
            navigationController: navigationController
        )
        return navigationController
    }
    
    private func setupChildCoordinators(
        tabKind: MainTab,
        navigationController: UINavigationController
    ) {
        var coordinator: Coordinator
        switch tabKind {
        case .home:
            coordinator = DefaultHomeCoordinator(
                parent: self, 
                navigationController: navigationController,
                coordinatorProvider: coordinatorProvider
            )
        case .settings:
            coordinator = DefaultSettingsCoordinator(
                navigationController: navigationController
            )
        case .alarm:
            coordinator = DefaultRegularAlarmCoordinator(
                navigationController: navigationController, 
                coordinatorProvider: coordinatorProvider
            )
        }
        childs.append(coordinator)
        coordinator.start()
    }
}
