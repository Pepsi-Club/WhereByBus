//
//  MockCoordinator.swift
//  FeatureDependency
//
//  Created by gnksbm on 3/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Domain

#if DEBUG
public final class MockCoordinator: Coordinator {
    public var parent: Coordinator?
    public var childs: [Coordinator] = []
    public var coordinatorType: CoordinatorType = .home
    
    private let testMessage: String
    public var navigationController: UINavigationController
    
    public init(
        testMessage: String,
        navigationController: UINavigationController
    ) {
        self.testMessage = testMessage
        self.navigationController = navigationController
    }
    
    public func start() {
        let testViewController = UIViewController()
        testViewController.view.backgroundColor = .white
        let testLabel = UILabel()
        testLabel.text = testMessage
        testLabel.numberOfLines = 0
        testLabel.font = .boldSystemFont(ofSize: 20)
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        testViewController.view.addSubview(testLabel)
        NSLayoutConstraint.activate([
            testLabel.centerXAnchor.constraint(
                equalTo: testViewController.view.centerXAnchor
            ),
            testLabel.centerYAnchor.constraint(
                equalTo: testViewController.view.centerYAnchor
            ),
        ])
        navigationController.pushViewController(
            testViewController,
            animated: true
        )
    }
}

extension MockCoordinator: HomeCoordinator {
    public func updateFavoritesState(isEmpty: Bool) {
        
    }
    
    public func startBusStopFlow(stationId: String) {
        let coordinator = MockCoordinator(
            testMessage: "BusStopFlow - busStopId: \(stationId)",
            navigationController: navigationController
        )
        coordinator.start()
        childs.append(coordinator)
    }
}

extension MockCoordinator: SearchCoordinator {
    public func startNearMapFlow() {
        
    }
    
    public func finishFlow() {
        navigationController.popViewController(animated: true)
        finish()
    }
}


extension MockCoordinator: BusStopCoordinator {
    public func example() {
        
    }
    
    
    public func popVC() {
        
    }
    
    public func moveToRegualrAlarm() {
        
    }
    
    public func busStopMapLocation(busStopId: String) {
        let coordinator = MockCoordinator(
            testMessage: "Map - busStopId: \(busStopId)",
            navigationController: navigationController
        )
        coordinator.start()
        childs.append(coordinator)
    }
}

extension MockCoordinator: AddRegularAlarmCoordinator {
    public func start(with: RegularAlarmResponse) {
        
    }
    
    public func startSearchFlow() {
        
    }
    
    public func removeChildViewController() {
        
    }
}

extension MockCoordinator: NearMapCoordinator {
    public func startBusStopFlow(busStopId: String) {
        let coordinator = MockCoordinator(
            testMessage: "BusStopFlow - busStopId: \(busStopId)",
            navigationController: navigationController
        )
        coordinator.start()
        childs.append(coordinator)
    }
}
#endif
