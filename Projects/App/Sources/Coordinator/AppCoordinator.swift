//
//  AppCoordinator.swift
//  YamYamPick
//
//  Created by gnksbm on 2023/11/23.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit

import FeatureDependency
import MainFeature

final class AppCoordinator: Coordinator {
    var parent: Coordinator?
    var childs: [Coordinator] = []
    var navigationController: UINavigationController
    public var coordinatorType: CoordinatorType = .app
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController, 
            coordinatorProvider: DefaultCoordinatorProvider()
        )
        childs.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}
