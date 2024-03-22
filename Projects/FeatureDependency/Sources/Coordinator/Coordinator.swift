//
//  Coordinator.swift
//  PresentationDependency
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core

public protocol Coordinator: AnyObject {
    var parent: Coordinator? { get set }
    var childs: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    var coordinatorType: CoordinatorType { get }
    
    func start()
    func finish()
}

public extension Coordinator {
    func finish() {
        parent?.childDidFinish(self)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        childs = childs.filter { $0 !== child }
    }
    
    func finishFlow() {
        navigationController.popViewController(animated: true)
        parent?.childDidFinish(self)
    }
    
    func finishFlow(
        upTo coordinatorKind: CoordinatorType
    ) {
        var currentCoordinator: Coordinator = self
        var isRoot = false
        while !isRoot {
            guard let nextCoordinator = currentCoordinator.parent else { break }
            currentCoordinator.finish()
            currentCoordinator = nextCoordinator
            isRoot = currentCoordinator.coordinatorType == coordinatorKind
        }
        // TODO: 재사용 로직으로 수정
        (currentCoordinator as? AddRegularAlarmCoordinator)?
            .removeChildViewController()
    }
}
